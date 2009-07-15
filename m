Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZGOPE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZGOPE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZGOPE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:04:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51218 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZGOPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:04:57 -0400
Date: Wed, 15 Jul 2009 02:04:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible Suspend to Ram bug?
Message-ID: <20090715000417.GB1552@ucw.cz>
References: <200907100458.27410.tfjellstrom@shaw.ca> <200907150359.12187.tfjellstrom@shaw.ca> <alpine.LNX.2.00.0907151330180.813@wotan.suse.de> <200907150545.14867.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907150545.14867.tfjellstrom@shaw.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-15 05:45:14, Thomas Fjellstrom wrote:
> On Wed July 15 2009, Jiri Kosina wrote:
> > On Wed, 15 Jul 2009, Thomas Fjellstrom wrote:
> > > I'll try with debian's 2.6.30 first. But there's a small issue with
> > > that, .30 and .31 seem to have some performance regressions according to
> > > sites like phoronix.
> >
> > You know, there are lies, then horrible lies, then benchmarks, and
> > benchmarks done wrong.
> >
> > Just do your own measurements under your particular workload, and if you
> > see any performance regression, just report it.
> 
> The benchmarks they run are pretty much what I'd do to test, so I'd more than 
> likely get the same results, and waste a bunch of time.

So rather you expect us to waste a bunch of time?

> 2.6.30 did seem to fix the ssd error. but the first time I suspended, my r8169 
> decided to flip out. I had to rmmod and modprobe it to get the network back 
> up.
> 
> [  867.780034] ------------[ cut here ]------------
> [  867.780165] WARNING: at 
> /home/blank/debian/kernel/tmp/linux-2.6-2.6.30/debian/build/source_amd64_none/net/sched/sch_generic.c:226 
> dev_watchdog+0xc7/0x164()
> [  867.780373] Hardware name: GA-MA790FXT-UD5P
> [  867.780488] NETDEV WATCHDOG: eth1 (r8169): transmit timed out
> [  867.780610] Modules linked in: nvidia(P) powernow_k8 cpufreq_conservative 
> cpufreq_stats cpufreq_userspace cpufreq_powersave nfsd exportfs nfs lockd 
> fscache nfs_acl auth_rpcgss sunrpc it87 hwmon_vid adt7473 firewire_sbp2 loop 
> snd_hda$
> [  867.785472] Pid: 0, comm: swapper Tainted: P

....and some more.


> At this point I was getting repeated "link up" messages and even though 
> ifconfig said the network was up, there was no actual connectivity. as 
> mentioned only rmmod+modprobe of r8169 fixed the problem. It doesn't seem to 
> happen often though.

Reproduce it without taints, then youu can report a regression in network...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
