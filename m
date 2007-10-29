Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXJ2Us4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXJ2Us4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXJ2Uss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:48:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXJ2Usr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:48:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Subject: Re: [2.6.23] IBM X41 looses time after Suspend2Disk
Date: Mon, 29 Oct 2007 22:05:10 +0100
User-Agent: KMail/1.9.5
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@suse.cz>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071029201955.GA1955@titan.lahn.de>
In-Reply-To: <20071029201955.GA1955@titan.lahn.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292205.11459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 29 October 2007 21:19, Philipp Matthias Hahn wrote:
> Hello Thomas, Pavel, Rafael!
> 
> I have an IBM X41 tablet pc running 2.6.23 with the following problem:
> Suspend2Ram work fine, but when I do a Suspend2Disk (echo disk >
> /sys/power/state), the notebook hangs showing the following lines:
>         Stopping tasks ... done.
>         Shrinking memory... done (49361 pages freed)
>         Freed 197444 kbytes in 0.64 seconds (308.50 MB/s)
>         Suspending console(s)
> 
> When I repeatedly press some keys or move the TrackPoint, the SwSusp
> continues and the notebook powers off.
> On reboot, the notebook resumes but hangs showing the following screen:
>         Stopping tasks ... done.
>         Loading image data pages (62483 pages) ... done
>         Read 249932 kbytes in 18.63 seconds (13.41 MB/s)
>         Suspending console(s)
> 
> Generating interrupts by pressing keys or moving the TrackPoints makes
> the resume continue. But after that, the notebook looses time, xterms
> don't get updated until I press a key, the beeper beeps until I press a
> key, etc.
> 
> Any idea what the problem might be?

Nope.

> DMESG: http://corellon.svs.informatik.uni-oldenburg.de/~pmhahn/x41.dmesg
> CONFIG: http://corellon.svs.informatik.uni-oldenburg.de/~pmhahn/x41.config
> 
> If you need more data, just ask.

Please try to do "echo shutdown > /sys/power/disk" before hibernation and
see what happens.

Also, is it an SMP kernel or UP?

Rafael
