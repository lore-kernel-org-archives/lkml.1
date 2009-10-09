Return-Path: <linux-kernel-owner+w=401wt.eu-S934422AbZJIVXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422AbZJIVXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934141AbZJIVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:23:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123AbZJIVXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:23:38 -0400
Date: Fri, 9 Oct 2009 23:22:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH] move stk17ta8's probe function to .devinit.text
In-Reply-To: <20091009203319.28a220e6@i1501.lan.towertech.it>
Message-ID: <alpine.LSU.2.00.0910092322250.19284@wotan.suse.de>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-27-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-28-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-29-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-31-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-32-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-33-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-34-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-35-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-36-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LSU.2.00.0910091724170.19284@wotan.suse.de> <20091009203319.28a220e6@i1501.lan.towertech.it>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Alessandro Zummo wrote:

> > > -static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
> > > +static int __devinit stk17ta8_rtc_probe(struct platform_device *pdev)
> > >  {
> > >  	struct rtc_device *rtc;
> > >  	struct resource *res;  
> > 
> > This seems to get lost ... should I take it through my tree, or is anyone 
> > going to merge it? Andrew? Alessandro?
>  Did you sent it to the rtc mailing list? I can't find it in patchwork.

It was probably sent only to you personally ...

>  You can carry it in your tree.
>  Acked-by: Alessandro Zummo <a.zummo@towertech.it>

Queued, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
