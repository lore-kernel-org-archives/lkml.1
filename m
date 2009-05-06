Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbZEFWgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbZEFWgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760985AbZEFWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:36:08 -0400
Received: from sentrion1.jpl.nasa.gov ([128.149.139.105]:62086 "EHLO
	mail.jpl.nasa.gov" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757383AbZEFWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:36:07 -0400
Subject: Re: what are some more advanced error collection methods?
From: Al Niessner <Al.Niessner@jpl.nasa.gov>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1241644672.8424.62.camel@morte.jpl.nasa.gov>
References: <1241644672.8424.62.camel@morte.jpl.nasa.gov>
Content-Type: text/plain
Date: Wed, 06 May 2009 15:36:04 -0700
Message-Id: <1241649364.8424.66.camel@morte.jpl.nasa.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Source-IP: morte.jpl.nasa.gov [137.78.15.44]
X-Source-Sender: Al.Niessner@jpl.nasa.gov
X-AUTH: Authorized
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using a volt meter, I verified that the 5V and 12V are good and the
computer is running under a normal load. So, I am going to go with the
power supply being alright for now.

I changed the CPU temperature by a couple of degrees with no failure.
While I cannot rule this out, I am willing to lean toward a software
problem; meaning, the kernel is hard locking.

Now I just need some way to get some helpful information out if it so
that I can move toward a solution.

On Wed, 2009-05-06 at 14:17 -0700, Al Niessner wrote:
> I am running 2.6.27 on an AMD 64 x2 dual core 6000+. I have the OS
> installed its own disk (SATA) and have an mdraid (SATA) with 3 disks
> being mirrored for my critical data. I also have an mdraid with 2 disks
> being mirrored (USB but I wanted firewire) for very low rate data. Both
> mdraids are nfs mounted and use automount on top of that -- nothing
> peculiar about nfs and automount except that nfs is over two networks
> each with their own NIC. My problem is that every 36 hours the machine
> simply locks up. Here is what I find:
> 
> 1) num lock light is on but was off prior to lock up
> 2) no response to beating the num and caps lock keys
> 3) no response to beating the sysreq key plus any sequences
> 4) nothing is recorded in kern.log, syslog, or any other log file
> in /var/log
> 5) cannot get to console because keyboard is dead
> 6) have to hold power switch for 10 seconds to get computer to turn off
> so the computer is not suspended (power management is not installed
> anyway)
> 7) when computer is rebooted, the mdraids are usually clean (no resync)
> 8) did a memtest and it passes
> 
> Since nothing showed up in the logs and I could not read the console, I
> found an old computer and connected the one I care about to it via
> ttyS0. Now I have the console even though the keyboard is dead. However,
> when the lock up occurs, there is absolutely no output to my RS232
> console. I put a pulse onto the console via /dev/console and get stuff
> right up until the change of state, but no panic shows up. On reboot, I
> start getting characters from the kernel immediately. Hence, I have to
> conclude that the serial connection is viable, but there is simply no
> output from the kernel.
> 
> So, I have tried all of the simple stuff that I know about or found via
> google. Now I would like some more advanced ways of trying to pry
> helpful information from a dying kernel. Are there more advanced tools,
> tricks, or secrets for collecting fault information?
> 
> Any and all help is appreciated in advance.
> 
> One last item, I am still working on determining if this is a hardware
> or software problem. The voltages look resonable and the room is
> thermally stable to +/- 1C. So, I am having a hard time blaming
> hardware.
> 
-- 
Al Niessner
818.354.0859

--------
|  dS  | >= 0
--------

