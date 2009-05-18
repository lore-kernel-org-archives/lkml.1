Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZERLoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZERLoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZERLnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:43:55 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:45963 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbZERLny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:43:54 -0400
Subject: RE: [PATCH] LP3971 PMIC regulator driver update
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       kyungmin.park@samsung.com, "'Mark Brown'" <mark.brown@wolfsonmicro.com>
In-Reply-To: <000601c9d7ac$58af73d0$0a0e5b70$%szyprowski@samsung.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local>
	 <20090515092030.GA2202@rakim.wolfsonmicro.main>
	 <1242641718.5473.2156.camel@vega.slimlogic.co.uk>
	 <000601c9d7ac$58af73d0$0a0e5b70$%szyprowski@samsung.com>
Content-Type: text/plain
Date: Mon, 18 May 2009 12:43:52 +0100
Message-Id: <1242647032.5473.2162.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 13:32 +0200, Marek Szyprowski wrote:
> Hello, 
> 
> On Monday, May 18, 2009 12:15 PM Liam Girdwood wrote:
> 
> > On Fri, 2009-05-15 at 10:20 +0100, Mark Brown wrote:
> > > On Fri, May 15, 2009 at 11:16:19AM +0200, Marek Szyprowski wrote:
> > > > This patch fixes issues reported by Mark Brown in his review of
> > National Semiconductors LP3971
> > > > PMIC regulator driver. It contains:
> > > > - a little code cleanup
> > > > - list_voltage() callback added
> > >
> > > > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > >
> > > Looks good.
> > >
> > > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > Doesn't apply :-
> > 
> > Applying: LP3971 PMIC regulator driver update
> > error: patch failed: drivers/regulator/lp3971.c:91
> > error: drivers/regulator/lp3971.c: patch does not apply
> > Patch failed at 0001 LP3971 PMIC regulator driver update
> > 
> > Could you regenerate against the voltage for-next branch.
> 
> I've checked the
> git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git, the
> for-next branch. I looks that all tabs are converted to spaces in my
> previous patch. I've checked again it imho I've posted it properly. Maybe it
> was broken by merge conflicts in Makefile/Kconfig. What should I do in such
> case? Would you revert the broken version or do I need to post a patch for
> it?
> 

I think it broke during merge (my fault). :-/ I'll revert it for now. 

Could you resend and combine the original and update patches into the
one patch.

Thanks

Liam  

