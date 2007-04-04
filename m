Return-Path: <linux-kernel-owner+w=401wt.eu-S2992750AbXDDIpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992750AbXDDIpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992752AbXDDIpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:45:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992750AbXDDIpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:45:51 -0400
Date: Wed, 4 Apr 2007 10:45:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Dillow <dave@thedillows.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       ray-gmail@madrabbit.org, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
Message-ID: <20070404084530.GB1556@elte.hu>
References: <200704010100.19016.gene.heskett@verizon.net> <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com> <200704011141.53105.gene.heskett@verizon.net> <200704020021.02393.gene.heskett@gmail.com> <1175488272.3161.28.camel@obelisk.thedillows.org> <1175661256.31439.23.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175661256.31439.23.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Dillow <dave@thedillows.org> wrote:

> > Then it is a matter of figuring out why the device number changed -- 
> > I'm thinking it is device-mapper, but will look closer tomorrow.
> 
> This commit is the one that changed it:
> 
> commit fdf892be32d84a1745fa0aee5fc60517421b8038
> Author: Andrew Morton <akpm@osdl.org>
> Date:   Mon Feb 12 00:51:44 2007 -0800
> 
>     [PATCH] register_blkdev(): don't hand out the LOCAL/EXPERIMENTAL majors
>     
>     As pointed out in http://bugzilla.kernel.org/show_bug.cgi?id=7922, 
>     dynamic blockdev major allocation can hand out majors which LANANA 
>     has defined as being for local/experimental use.

i dont think we should break backwards compatibility with a system that 
has not changed any hardware. Andrew, should we revert this?

	Ingo
