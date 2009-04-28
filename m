Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbZD1KiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbZD1KiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZD1KiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:38:10 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:42467 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217AbZD1KiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:38:09 -0400
Subject: Re: Patch to add mioa701 glue for voltage regulation
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, eric.miao@marvell.com,
       broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <f17812d70904271813t2c67d929n67c84bb86f450e35@mail.gmail.com>
References: <87iqkvp6i3.fsf@free.fr>
	 <1240566136.27410.3291.camel@vega.slimlogic.co.uk> <87d4ax7qf3.fsf@free.fr>
	 <f17812d70904271813t2c67d929n67c84bb86f450e35@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 11:38:06 +0100
Message-Id: <1240915086.14165.111.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 09:13 +0800, Eric Miao wrote:
> On Tue, Apr 28, 2009 at 5:11 AM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> > Liam Girdwood <lrg@slimlogic.co.uk> writes:
> >
> >> On Thu, 2009-04-23 at 20:30 +0200, Robert Jarzmik wrote:
> >>> Hi Mark and Eric,
> >>>
> >>> I have that patch which adds voltage regulation definitions to mioa701
> >>> board. The trick is, this patch depends on two others :
> >>>
> >>>  - one which will be merged through Mark's regulator tree.
> >>>    This one is mandatory as a compiling dependency exists through include files.
> >>>
> >>>  - one which will be merge through Eric pxa tree.
> >>>    This is the cpufreq one, and has a "very weak" dependency, as only the
> >>>    "vcc_core" name _is_ the dependency.
> >>>
> >>> I think the easiest way to solve the compiling dependency
> >>> (include/linux/regulator.max1586.h) is to make that patch go through regulator
> >>> tree as well for linux-next, even if it's arm machine specific, don't you ?
> >>>
> >>
> >> If fine with this going through regulator providing I get an ACK from
> >> Eric.
> >
> > Eric,
> >
> > Since Liam took the max1586 regulator through his tree, would you state if you
> > ack that please ?
> >
> 
> I'd really be happy to. However, my concern is that this patch modifies
> arch/arm/mach-pxa/mioa701.c _only_, so it would be better to go through
> my tree so that I can manage all the potential merge conflicts. There are
> several other changes to mioa701.c and I expect the content in
> arch/arm/mach-pxa/* to be heavily changed due to recent addition
> of pxa168/pxa910 support.
> 
> The issue of dependency, as was always before, can be resolved by
> putting this into 'pending' and monitoring the status of merge window
> before sending the PULL request.
> 
> Liam,
> 
> Sounds OK to you?

Eric,

I think it probably better going through your PXA tree now (to avoid any
conflicts). I had originally thought this patch was part of a larger
series that mostly touched regulator.

Robert,

Could you resubmit to Eric. Mark or I will ack. Please remove the
max1586_v6_info until it has some consumers.

Thanks

Liam

