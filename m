Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYJOXeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYJOXeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYJOXdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:33:36 -0400
Received: from kroah.org ([198.145.64.141]:35177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752670AbYJOXdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:33:35 -0400
Date: Wed, 15 Oct 2008 16:30:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.1
Message-ID: <20081015233015.GA29333@kroah.com>
References: <20081015232950.GA29323@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015232950.GA29323@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 16e3fbb..65ab041 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION =
+EXTRAVERSION = .1
 NAME = Rotary Wombat
 
 # *DOCUMENTATION*
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 263e9e6..aa53fdd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -103,7 +103,8 @@ config CONTEXT_SWITCH_TRACER
 	  all switching of tasks.
 
 config DYNAMIC_FTRACE
-	bool "enable/disable ftrace tracepoints dynamically"
+	bool "enable/disable ftrace tracepoints dynamically (BROKEN)"
+	depends on BROKEN
 	depends on FTRACE
 	depends on HAVE_DYNAMIC_FTRACE
 	default y
