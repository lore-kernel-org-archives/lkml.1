Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYJ0VrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYJ0VrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJ0VrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:47:04 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:36756 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYJ0VrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:47:03 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix comile error of hdpuftrs
Date: Mon, 27 Oct 2008 22:46:58 +0100
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200810181537.13653.m.kozlowski@tuxland.pl> <20081026212401.f3a6ee4d.akpm@linux-foundation.org>
In-Reply-To: <20081026212401.f3a6ee4d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810272246.59328.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > drivers/misc/hdpuftrs/hdpu_nexus.c:118: error: expected identifier or '(' before 'return'
> > drivers/misc/hdpuftrs/hdpu_nexus.c:119: error: expected identifier or '(' before '}' token
> > 
> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > 
> > --- a/drivers/misc/hdpuftrs/hdpu_nexus.c
> > +++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
> > @@ -113,7 +113,6 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
> >  	if (!hdpu_chassis_id)
> >  		printk(KERN_WARNING "sky_nexus: "
> >  		       "Unable to create proc dir entry: sky_chassis_id\n");
> > -	}
> > 
> >  	return 0;
> >  }
> 
> This has been broken since 2.6.26.
> 
> Nobody noticed because there is no way of enabling CONFIG_HDPU_FEATURES
> in Kconfig.  I wonder what's up with that.

Yup. I used simple script to find the brace imbalance. Then I tried to compile it with
make drivers/misc/hdpuftrs/hdpu_nexus.o to verify this.

	Mariusz
