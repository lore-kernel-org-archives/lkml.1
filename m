Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYLSMFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYLSMFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 07:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYLSMFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 07:05:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56225 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYLSMFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 07:05:36 -0500
Date: Fri, 19 Dec 2008 13:05:30 +0100
From: Pavel Machek <pavel@suse.cz>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Halted system won't halt
Message-ID: <20081219120530.GB1599@ucw.cz>
References: <494A0711.7010804@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494A0711.7010804@davidnewall.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-12-18 18:47:21, David Newall wrote:
> I've got a remote machine running ubuntu 2.6.24-19-generic which I ssh
> into.  When I said "poweroff -f -p" it strangely came back after a few
> seconds.  Perhaps my banging on the keyboard made a difference.  The
> same thing happened when I said "halt -f -p".  Sounds like user error to
> me, except the log file shows kernel halt messages.  These are the last
> n lines logged:
> 
> Dec 19 01:48:32 ubuntu -- MARK --
> Dec 19 02:08:32 ubuntu -- MARK --
> Dec 19 02:18:20 ubuntu kernel: [40201.658595] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
> Dec 19 02:22:02 ubuntu kernel: [40423.339196] sd 1:0:1:0: [sda] Stopping disk
> Dec 19 02:22:03 ubuntu kernel: [40424.243004] System halted.
> Dec 19 02:23:33 ubuntu kernel: [40514.506694] sd 1:0:1:0: [sda] Stopping disk
> Dec 19 02:23:33 ubuntu kernel: [40514.506748] ata2.01: DISK MIGHT NOT BE SPUN DOWN PROPERLY. UPDATE SHUTDOWN UTILITY
> Dec 19 02:23:33 ubuntu kernel: [40514.506756] ata2.01: For more info, visit http://linux-ata.org/shutdown.html
> Dec 19 02:23:38 ubuntu kernel: [40519.703866] psmouse.c: Failed to deactivate mouse on isa0060/serio1
> Dec 19 02:23:40 ubuntu kernel: [40521.903111] System halted.
> 

SMP? Care to try Mark Lord's recent patch on lkml?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
