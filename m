Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYBWX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYBWX5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYBWX5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:57:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49363 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754863AbYBWX5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:57:25 -0500
Date: Sun, 24 Feb 2008 00:57:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Subject: jffs2: -ENOSPC when truncating file?!
Message-ID: <20080223235742.GE2202@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm trying to free space by truncating big file, and I get:

root@fic-gta01:~# ls -al gps.nmea 
-rw-r--r--    1 root     root      2332070 Feb 19 22:13 gps.nmea
root@fic-gta01:~# > gps.nmea 
-sh: cannot create gps.nmea: No space left on device
root@fic-gta01:~# rm gps.nmea
root@fic-gta01:~# > gps.nmea
root@fic-gta01:~# 

:-(

Kernel is not-so-ancient, on openmoko:

root@fic-gta01:~# uname -a
Linux fic-gta01 2.6.24 #1 PREEMPT Mon Feb 18 21:30:53 GMT 2008 armv4tl
unknown
root@fic-gta01:~# 


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
