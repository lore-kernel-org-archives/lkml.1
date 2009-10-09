Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbZJISeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbZJISeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761305AbZJISeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:34:08 -0400
Received: from mx0.towertech.it ([213.215.222.73]:49736 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761303AbZJISeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:34:05 -0400
Date: Fri, 9 Oct 2009 20:33:19 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH] move stk17ta8's probe function to .devinit.text
Message-ID: <20091009203319.28a220e6@i1501.lan.towertech.it>
In-Reply-To: <alpine.LSU.2.00.0910091724170.19284@wotan.suse.de>
References: <20090711170548.GC5205@suse.de>
	<1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-27-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-28-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-29-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-31-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-32-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-33-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-34-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-35-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-36-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.LSU.2.00.0910091724170.19284@wotan.suse.de>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 17:24:51 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> > -static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
> > +static int __devinit stk17ta8_rtc_probe(struct platform_device *pdev)
> >  {
> >  	struct rtc_device *rtc;
> >  	struct resource *res;  
> 
> This seems to get lost ... should I take it through my tree, or is anyone 
> going to merge it? Andrew? Alessandro?

 Did you sent it to the rtc mailing list? I can't find it in patchwork.
 You can carry it in your tree.
 
 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

