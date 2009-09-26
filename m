Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZIZPW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZIZPW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZIZPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:22:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:49640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZIZPW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:22:26 -0400
Subject: Re: [PATCH] ARM: Remove unused CONFIG reference DEBUG_S3C_PORT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Byungho Min <bhmin@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0909261002400.19973@localhost>
References: <1253973658.4568.10.camel@ht.satnam>
	 <alpine.LFD.2.00.0909261002400.19973@localhost>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 20:51:55 +0530
Message-Id: <1253978515.4568.50.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Sat, 2009-09-26 at 10:03 -0400, Robert P. J. Day wrote:
> On Sat, 26 Sep 2009, Jaswinder Singh Rajput wrote:
> 
> >
> > Remove unused CONFIG reference DEBUG_S3C_PORT from defconfig
> >
> > Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Cc: Byungho Min <bhmin@samsung.com>
> > Cc: Ben Dooks <ben-linux@fluff.org>
> > Cc: Russell King <rmk+lkml@arm.linux.org.uk>
> > ---
> >  arch/arm/configs/s5pc100_defconfig |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/arm/configs/s5pc100_defconfig b/arch/arm/configs/s5pc100_defconfig
> > index b0d7d3d..94edde5 100644
> > --- a/arch/arm/configs/s5pc100_defconfig
> > +++ b/arch/arm/configs/s5pc100_defconfig
> > @@ -859,7 +859,6 @@ CONFIG_DEBUG_ERRORS=y
> >  # CONFIG_DEBUG_STACK_USAGE is not set
> >  CONFIG_DEBUG_LL=y
> >  # CONFIG_DEBUG_ICEDCC is not set
> > -CONFIG_DEBUG_S3C_PORT=y
> >  CONFIG_DEBUG_S3C_UART=0
> 
>   no, there is no point removing redundant entries from any of the
> defconfig files -- those files will eventually be rebuilt
> automatically at some point.
> 

Who will build defconfig for old architectures like h3600_defconfig and
others.

If we are removing unused CONFIG from Kconfig then there is no point of
leaving those entries in defconfigs after all git grep keep those
entries and lead to confusions sooner or later. Yeah, for this case
where we have only entry in defconfig you sounds good but let
maintainers will decide it :-)

Thanks,
--
JSR



