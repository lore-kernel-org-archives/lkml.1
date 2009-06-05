Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZFEHaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZFEHaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZFEHaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:30:13 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:33329 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZFEHaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:30:12 -0400
Date: Fri, 5 Jun 2009 09:27:09 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090605072709.GG6411@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041227.10529.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:27:07PM -0500, Michael S. Zick wrote:
> On Thu June 4 2009, Linus Torvalds wrote:
> > 
> > Side note: is it more stable if you disable the VIA speedstep thing 
> > (whatever it's called (ok, google tells me it's called "TwinTurbo" and 
> > "Advanced PowerSaver")?
> >
> 
> The e_powersave code.

that is only for the early C7, as I've been told by Centaur.  C7-M should
definitely support the ACPI states.  So better to disable both.

> It was a fixed-speed kernel build that first hit the 4 hour up-time mark.
> I just reposted that build today (the -09143lk).

did you actually check if the power transitions are on longer happening?

> For want of a documented JTAG port...

there is JTAG on the CPU, but only for EXTEST/INTEST, i.e. access to the actual
signal lanes for making sure all the BGA pads are soldered and actually connect
to the right signals of the next component on the board.  There is no embedded
ICE or anything of that sort.  Also, your board most likely doesn't have JTAG
on an accessible connector, since it's out of mass production.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
