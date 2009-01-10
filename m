Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZAJWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZAJWP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZAJWPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:15:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZAJWPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:15:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: 2.6.27.9 - Resuming from hibernate locks after "CPU1 is down"
Date: Sat, 10 Jan 2009 23:15:02 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>
References: <20081225230934.380c953f@tux.DEF.witbe.net> <20081225201241.2f6b6e7c@tux.DEF.witbe.net>
In-Reply-To: <20081225201241.2f6b6e7c@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901102315.02729.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 25 December 2008, Paul Rolland wrote:
> Self replying, just to add that 2.6.28 has the same behavior.
> 
> Regards,
> Paul
> 
> On Thu, 25 Dec 2008 23:09:34 +0100
> Paul Rolland <rol@as2917.net> wrote:
> 
> > Hello,
> > 
> > I'm trying to have suspend to disk and suspend to RAM work on my machine
> > (Dell Inspiron 6400, 2Go RAM, with an Intel Mobile 945GM/GMS, 943/940GM
> > L Express Integrated Graphics Controller.
> > 
> > To suspend, I'm using the "echo mem | disk > /sys/power/state" command.
> > 
> > As of now, using suspend to RAM allow the machine to suspend, and resume
> > is nearly OK except the video is not restored, and the screen stays black
> > (but keyboard is Ok, I can launch any command I want, so I can restart).
> > 
> > When suspending to disk, suspend is Ok with :
> > echo -n 2097152000 > /sys/power/image_size ;
> > echo -n disk > /sys/power/state
> > and resuming detects the image in the swap partition. So, I have on the
> > console, when I add "no_console_suspend" on the boot command line :
> > PM: loading image data pages...
> > PM: read xxxxx kbytes in y.zz seconds
> > ...
> > [stuff about scsi/sda]
> > Disabling non-boot CPUs
> > CPU1 is now offlone
> > SMP alternatives: switching to UP code
> > CPU1 is down
> > 
> > and then, nothing :( machine is dead frozen. CAPS Lock doesn't toggle the
> > keyboard LED anymore, I need to manually power off and power on the
> > machine.
> > 
> > I must add that these are my first attempts. So, this is not to be
> > considered a regression.
> > 
> > Is there anything else I can do to try to debug the resume ?

As Pavel alread said, please boot the kernel with init=/bin/bash , mount /sys,
mount /proc, run 'swapon -a' and try to hibernate-resume.

Thanks,
Rafael
