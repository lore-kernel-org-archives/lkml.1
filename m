Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZGMVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZGMVb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbZGMVb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:31:59 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:36244 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757322AbZGMVb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:31:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DGtwQ3sUcuASlNfBaJ/65EZkKKYkQGUec8ds0P3nmrLbRsangn+DcUUtOcZYLYXYqUMKRqBKHLsxL22oQcPJgyHVUx/tcJI+jq7D3lnZ6CcJSgtDUp9RdgjUJFe4PfPlSlKRmnHRZLZDmJg77mqlE1snDdp5TGLEeu+h4AdQOKc=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: 86du5U8VM1n9M5VfFweZOwFRw7zjaNiCS.475zCRUQzyn5PSzK0xlORbQwoEqwKuhFtAODm5qBZDpEEDCqXhGDSl81rP4NUDHYny3sqlgaE8t32VitfB4mogPSx1f2meuK7r7i.sTSv.eVjq1tkYMCYZZhfVcjMAfgLUtNlSk_VEedO_N6ROsCkrFKt_s93usJbyBLoaKfZfxpRLUKngSJ6TmWrKZGRYmZd_sFxvStvckosi6faf50h9eXvIH34C26KfvBk7Sp4bd3oi
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Date: Mon, 13 Jul 2009 14:31:54 -0700
User-Agent: KMail/1.9.10
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <20090711170548.GC5205@suse.de> <200907121521.31188.david-b@pacbell.net> <20090713091034.GC10549@pengutronix.de>
In-Reply-To: <20090713091034.GC10549@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907131431.54233.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, Uwe Kleine-König wrote:
> > If it weren't a regression I wouldn't have objected.
> 
> IMHO my patches primarily fix possible oopses.  I see your point that
> platform_driver_probe has some advantages, 

The point is that your specific change caused a type
of regresssion ... I said nothing about "advantages",
just that your approach creates footprint regressions.


> 			but I consider it too
> time-consuming to check for each of the initially 60+ patches when the
> respecting devices are registered.

As a rule, preventing regressions is part of the task
description for any patch series.

Now, accidents do happen.  But you had *ALREADY* gotten
NAKs for many of these patches, specifically on the
basis that they were causing these regressions.  You
saved zero time by re-submitting known-broken patches.

