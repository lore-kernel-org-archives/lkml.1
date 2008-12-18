Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752217AbYLRIRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbYLRIRf (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYLRIRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:17:25 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39089 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYLRIRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:17:24 -0500
Message-ID: <494A0711.7010804@davidnewall.com>
Date: Thu, 18 Dec 2008 18:47:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Halted system won't halt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a remote machine running ubuntu 2.6.24-19-generic which I ssh
into.  When I said "poweroff -f -p" it strangely came back after a few
seconds.  Perhaps my banging on the keyboard made a difference.  The
same thing happened when I said "halt -f -p".  Sounds like user error to
me, except the log file shows kernel halt messages.  These are the last
n lines logged:

Dec 19 01:48:32 ubuntu -- MARK --
Dec 19 02:08:32 ubuntu -- MARK --
Dec 19 02:18:20 ubuntu kernel: [40201.658595] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
Dec 19 02:22:02 ubuntu kernel: [40423.339196] sd 1:0:1:0: [sda] Stopping disk
Dec 19 02:22:03 ubuntu kernel: [40424.243004] System halted.
Dec 19 02:23:33 ubuntu kernel: [40514.506694] sd 1:0:1:0: [sda] Stopping disk
Dec 19 02:23:33 ubuntu kernel: [40514.506748] ata2.01: DISK MIGHT NOT BE SPUN DOWN PROPERLY. UPDATE SHUTDOWN UTILITY
Dec 19 02:23:33 ubuntu kernel: [40514.506756] ata2.01: For more info, visit http://linux-ata.org/shutdown.html
Dec 19 02:23:38 ubuntu kernel: [40519.703866] psmouse.c: Failed to deactivate mouse on isa0060/serio1
Dec 19 02:23:40 ubuntu kernel: [40521.903111] System halted.


I can't explain that.
