Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYKYPrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYKYPrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKYPrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:47:11 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:37808 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYKYPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:47:10 -0500
Date: Tue, 25 Nov 2008 16:40:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081125154011.GA4883@uranus.ravnborg.org>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com> <20081125055744.c3377164.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125055744.c3377164.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Mathieu, if you're feeling keen I'd suggest that you just type `mkdir
> -p userspace/lttng' and build your userspace tools in there.

Maybe this can help...

	Sam

diff --git a/usr/Makefile b/usr/Makefile
index 201f27f..627fafc 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -2,6 +2,8 @@
 # kbuild file for usr/ - including initramfs image
 #
 
+subdir-y := lttng
+
 klibcdirs:;
 PHONY += klibcdirs
 
diff --git a/usr/lttng/Makefile b/usr/lttng/Makefile
new file mode 100644
index 0000000..8667998
--- /dev/null
+++ b/usr/lttng/Makefile
@@ -0,0 +1,4 @@
+
+always := ltt
+
+hostprogs-y := ltt
diff --git a/usr/lttng/ltt.c b/usr/lttng/ltt.c
new file mode 100644
index 0000000..9eca2ed
--- /dev/null
+++ b/usr/lttng/ltt.c
@@ -0,0 +1,7 @@
+#include <stdio.h>
+
+int main(int ac, char *argv[])
+{
+	printf("lttng\n");
+	return 0;
+}
