Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbXIRVrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbXIRVrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXIRVrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:47:31 -0400
Received: from 1wt.eu ([62.212.114.60]:2568 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXIRVra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:47:30 -0400
Date: Tue, 18 Sep 2007 23:47:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ville Herva <v@iki.fi>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070918214705.GG10199@1wt.eu>
References: <20070918122314.GL29062@vianova.fi> <20070918151206.GC13304@atrey.karlin.mff.cuni.cz> <20070918160949.GR29062@vianova.fi> <20070918162256.GA3280@atrey.karlin.mff.cuni.cz> <20070918163326.GT29062@vianova.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918163326.GT29062@vianova.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ville,

On Tue, Sep 18, 2007 at 07:33:26PM +0300, Ville Herva wrote:
> On Tue, Sep 18, 2007 at 06:22:56PM +0200, you [Jan Kara] wrote:
> > > Sorry for the sparse details, but when you have these kind of problems on
> > > live servers, you tend to forget the debuggability...
> >   Yes, I can understand that :). It's just that now it's hard to find
> > out what has really happened. Anyway, thanks for your report.
> 
> If we are really lucky or unlucky it will happen again. 
> 
> Zeroed-out block just might be a kernel problem (SMP race, whatever) -
> random corruption would more likely be a hardware problem. There were no IO
> error either. But, 2.4 ext3 has been pretty extensively tested, so I don't
> suppose that's likely either. And judging from
> http://www.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.3[45] there
> haven't been many changes to ext3 lately either.

Thanks for your report. Unfortunately, I've rechecked the recent changelogs
and see nothing related either. At least, in order to keep trace of the
incident, would you please post some info about your config (CPU, RAM,
chipset, .config, gcc, and any possible patches you may have applied) ?
Maybe some of these info may remind old bad memories to some people.

Also, do you know if this server has ECC memory ? I would more easily
bet for side effects of one random bit flip in memory than for some
massive block corruption.

I vaguely remember about very old reports of people sometimes observing
zeroed out blocks during writes, which were attributed to chipset bugs
if my memory serves me. But I would rule this out as recent chipsets
look more stable than 5-10 years ago !

Regards,
Willy

