Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZF3NVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZF3NVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZF3NVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:21:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54350 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZF3NVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:21:15 -0400
Date: Tue, 30 Jun 2009 15:21:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, pierre@ossman.eu, swetland@google.com,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@google.com>
Subject: Re: [PATCH 0/3] msm_sdcc: A few more cleanups
Message-ID: <20090630132112.GB28447@elf.ucw.cz>
References: <20090629214101.GA12043@elf.ucw.cz> <cover.1246319479.git.joe@perches.com> <20090630065747.GA19260@elf.ucw.cz> <1246365021.10129.146.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246365021.10129.146.camel@Joe-Laptop.home>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-30 05:30:21, Joe Perches wrote:
> On Tue, 2009-06-30 at 08:57 +0200, Pavel Machek wrote:
> > diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
> > -	do_div(clks, NSECS_PER_SEC);
> > +	do_div(clks, NSEC_PER_SEC);
> 
> Compiling is good.  Submitting uncompiled patches not so good...

:-) Thanks for doing the cleanups. You know, fixing two compile
problems is easy compared to cleanups you did.

Can you fold those two fixups to your patches, or how to proceed?

> > @@ -588,6 +588,8 @@ static void
> >  msmsdcc_handle_irq_data(struct msmsdcc_host *host, struct mmc_data *data,
> >  			u32 status)
> >  {
> > +	void __iomem	*base = host->base;
> > +
> 
> I don't know how performance sensitive this is.
> 
> Maybe it should be inline and have base passed
> as an argument.

I don't think it is _that_ performance critical.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
