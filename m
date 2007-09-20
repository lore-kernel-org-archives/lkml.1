Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbXITNV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbXITNV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXITNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:21:21 -0400
Received: from 1wt.eu ([62.212.114.60]:2580 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbXITNVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:21:21 -0400
Date: Thu, 20 Sep 2007 15:20:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ville Herva <v@iki.fi>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070920132055.GB12291@1wt.eu>
References: <20070918122314.GL29062@vianova.fi> <20070918151206.GC13304@atrey.karlin.mff.cuni.cz> <20070918160949.GR29062@vianova.fi> <20070918162256.GA3280@atrey.karlin.mff.cuni.cz> <20070918163326.GT29062@vianova.fi> <20070918214705.GG10199@1wt.eu> <20070920124537.GB5076@vianova.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920124537.GB5076@vianova.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ville,

On Thu, Sep 20, 2007 at 03:45:37PM +0300, Ville Herva wrote:
> On Tue, Sep 18, 2007 at 11:47:05PM +0200, you [Willy Tarreau] wrote:
> > Thanks for your report. Unfortunately, I've rechecked the recent changelogs
> > and see nothing related either. At least, in order to keep trace of the
> > incident, would you please post some info about your config (CPU, RAM,
> > chipset, .config, gcc, and any possible patches you may have applied) ?
> > Maybe some of these info may remind old bad memories to some people.
> > 
> > Also, do you know if this server has ECC memory ? I would more easily
> > bet for side effects of one random bit flip in memory than for some
> > massive block corruption.
> > 
> > I vaguely remember about very old reports of people sometimes observing
> > zeroed out blocks during writes, which were attributed to chipset bugs
> > if my memory serves me. But I would rule this out as recent chipsets
> > look more stable than 5-10 years ago !
> 
> Willy,
> 
> The machine is a virtual machine on an VMware ESX 3.0.1 host.
> 
> /proc/cpuinfo shows two of these:
> Dual
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
> stepping        : 8
> cpu MHz         : 2333.014
> cache size      : 64 KB
> 
> It has 864MB of memory.
> 
> .config is at:
> http://v.iki.fi/~vherva/tmp/2.4.35-config
> The kernel is plain vanilla 2.4.35 from kernel.org, no patches.

OK. And your config seems perfectly standard.

> gcc 2.96-129:
> cat /proc/version 
> Linux version 2.4.35 (root) (gcc version 2.96 20000731 (Red Hat Linux 7.2 2.96-129.7.2)) #1 SMP Thu Aug 9 10:35:37 EEST 2007

I used not to trust 2.96, but I wouldn't accuse it now.

> Memory is ECC.
> 
> The server is HP Proliant ML370 with 82801BA/CA/DB/EB chipset. I've had my
> share of chipset bugs with older Via chipsets, but I think it's very likely
> in this case.

I think you meant "unlikely".

> This could very well be a VMware bug, but I wanted to know if this rings
> bells for someone.

It could also be a problem with the host OS, drivers, hardware, etc...

Cheers,
Willy

