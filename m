Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbZACUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbZACUKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbZACUKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:10:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50287 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZACUKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:10:43 -0500
Date: Sat, 3 Jan 2009 13:44:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: atomics: document that linux expects certain atomic behaviour from
	unsigned long
Message-ID: <20090103124400.GA1572@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux relies on unsigned long to behave like atomic for read/write.
diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 4ef2450..0a7d180 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -21,6 +21,9 @@ local_t is very similar to atomic_t. If the counter is per CPU and only
 updated by one CPU, local_t is probably more appropriate. Please see
 Documentation/local_ops.txt for the semantics of local_t.
 
+unsigned long can be used instead of atomic_t, if all you
+need is atomic setting and atomic reading.
+
 The first operations to implement for atomic_t's are the initializers and
 plain reads.
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
