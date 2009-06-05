Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZFEHmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZFEHmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZFEHmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:42:40 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:58476 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZFEHmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:42:39 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Fri, 5 Jun 2009 02:41:09 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org> <20090605072709.GG6411@prithivi.gnumonks.org>
In-Reply-To: <20090605072709.GG6411@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906050241.11908.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Harald Welte wrote:
> On Thu, Jun 04, 2009 at 12:27:07PM -0500, Michael S. Zick wrote:
> > On Thu June 4 2009, Linus Torvalds wrote:
> > > 
> > > Side note: is it more stable if you disable the VIA speedstep thing 
> > > (whatever it's called (ok, google tells me it's called "TwinTurbo" and 
> > > "Advanced PowerSaver")?
> > >
> > 
> > The e_powersave code.
> 
> that is only for the early C7, as I've been told by Centaur.  C7-M should
> definitely support the ACPI states.  So better to disable both.
> 
> > It was a fixed-speed kernel build that first hit the 4 hour up-time mark.
> > I just reposted that build today (the -09143lk).
> 
> did you actually check if the power transitions are on longer happening?
> 

No - without a /sys...cpufreq directory I don't know how to do that.
But the machine is performing exactly as if it was at a fixed speed of 600Mhz.

Much different than when e_powersaver is included - -

Also, the e_powersaver stats look reasonable when compared with test loads
running, so although this may be an acpi controlled system, e_powersaver
"thinks" it has control (and does make a difference in performance).
It is not that hard to tell subjectively the difference between 0.4Ghz
and 1.2Ghz.

Mike
> > For want of a documented JTAG port...
> 
> there is JTAG on the CPU, but only for EXTEST/INTEST, i.e. access to the actual
> signal lanes for making sure all the BGA pads are soldered and actually connect
> to the right signals of the next component on the board.  There is no embedded
> ICE or anything of that sort.  Also, your board most likely doesn't have JTAG
> on an accessible connector, since it's out of mass production.
> 


