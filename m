Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753396AbYLZSYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYLZSYV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Fri, 26 Dec 2008 13:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYLZSYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:24:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41608 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYLZSYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:24:04 -0500
Date: Thu, 1 Jan 1970 07:50:33 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul Rolland <rol@as2917.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27.9 - Resuming from hibernate locks after "CPU1 is down"
Message-ID: <19700101065033.GB1406@ucw.cz>
References: <20081225230934.380c953f@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225230934.380c953f@tux.DEF.witbe.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-12-25 23:09:34, Paul Rolland wrote:
> Hello,
> 
> I'm trying to have suspend to disk and suspend to RAM work on my machine
> (Dell Inspiron 6400, 2Go RAM, with an Intel Mobile 945GM/GMS, 943/940GM
> L Express Integrated Graphics Controller.
> 
> To suspend, I'm using the "echo mem | disk > /sys/power/state" command.
> 
> As of now, using suspend to RAM allow the machine to suspend, and resume is
> nearly OK except the video is not restored, and the screen stays black (but
> keyboard is Ok, I can launch any command I want, so I can restart).
> 
> When suspending to disk, suspend is Ok with :
> echo -n 2097152000 > /sys/power/image_size ;
> echo -n disk > /sys/power/state
> and resuming detects the image in the swap partition. So, I have on the
> console, when I add "no_console_suspend" on the boot command line :
> PM: loading image data pages...
> PM: read xxxxx kbytes in y.zz seconds
> ...
> [stuff about scsi/sda]
> Disabling non-boot CPUs
> CPU1 is now offlone
> SMP alternatives: switching to UP code
> CPU1 is down
> 
> and then, nothing :( machine is dead frozen. CAPS Lock doesn't toggle the
> keyboard LED anymore, I need to manually power off and power on the machine.
> 
> I must add that these are my first attempts. So, this is not to be
> considered a regression.
> 
> Is there anything else I can do to try to debug the resume ?

Try it with minimal config, init=/bin/bash is useful.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
