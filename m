Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbXCHQm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbXCHQm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXCHQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:42:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46606 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752526AbXCHQm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:42:57 -0500
Date: Thu, 8 Mar 2007 17:41:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: swsusp: platform notifications not properly undone in case of error
Message-ID: <20070308164143.GA1766@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


Using IPI No-Shortcut mode
swsusp: Resume From Partition /dev/sda1
PM: Checking swsusp image.
swsusp: Signature found, resuming
PM: Preparing processes for restore.
Stopping tasks ... done.
PM: Reading swsusp image.
Loading image data pages (125285 pages) ...     <3>swsusp: Resume
mismatch: version
Read 501140 kbytes in 0.01 seconds (50114.00 MB/s)
swsusp: Error -1 resuming
PM: Restore failed, recovering.
Restarting tasks ... done.
PM: Resume from disk failed.
md: Autodetecting RAID arrays.

...and machine boots, but moon icon keeps blinking.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
