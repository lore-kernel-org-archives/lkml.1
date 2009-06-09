Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZFIQA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZFIQA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZFIQAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:00:49 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:60696 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZFIQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:00:48 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Tue, 9 Jun 2009 11:00:45 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090608234830.GA27843@srcf.ucam.org> <200906090736.54463.lkml@morethan.org>
In-Reply-To: <200906090736.54463.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091100.47960.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue June 9 2009, Michael S. Zick wrote:
> On Mon June 8 2009, Matthew Garrett wrote:
> > On Mon, Jun 08, 2009 at 04:15:22PM -0500, Michael S. Zick wrote:
> > 
> > > Phooey, close but no cigar - - -
> > > 
> > > root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_available_frequencies
> > > 1200000 1000000 800000 600000 400000
> > > root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat stats/time_in_state
> > > 1200000 3281
> > > 1000000 120
> > > 800000 130
> > > 600000 234
> > > 400000 52980
> > > root@cb01:/sys/devices/system/cpu/cpu0/cpufreq
> > > 
> > > It loads, it appears to work, but that lowest 400Mhz has ACPI entries
> > > even though this is a 600Mhz..1200Mhz chip.
> > 
> > If the BIOS tables claim it then it's likely Windows uses it on the same 
> > hardware. What's the stability like with the ACPI code?
> > 
> 
> Too soon to say - those where first results (about par with "it boots"). ;)
> 
> Will be poking at this machine more today -
>

An interesting note - not sure if it is cosmetic or an indication
of something significant [sub-title: computer voodoo]: 

You see above that acpi-cpufreq has the frequencies listed in
decreasing order - -
The e_powersaver module lists them in increasing order. [????]

Mike
> * * * *
> 
> I do not have a copy of any proprietary operating system to compare with
> on this machine.
> 
> You could use the search features of this forum:
> http://forum.netbookuser.com/index.php
> to look for windows problem reports/discussions.
> 
> That forum was active since the machine was announced and included
> members from Everex.  If there where windows problems, they are
> in there somewhere.
> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


