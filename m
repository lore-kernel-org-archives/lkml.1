Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab0BXKYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:24:21 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:48510 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab0BXKYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:24:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Wvse5YoC3p9Z8TNDayNg6PfWOLWXF4PnmD6f6yYtQifcZwnNGSLFS1SADVRx7LMj0m
         /M2tH+lL+F2//8c6bBgey16vgGDoe0GlDyqrRxJwNVr7Qyko0jHiP+yjlFks9FdHlu5J
         DzWMR5ghfgjdEYXyT/ftJix4iGgS66vORf7Z0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 08/14] Regulators: max1586 - annotate probe and remove methods
Date: Wed, 24 Feb 2010 02:16:08 -0800
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8; KDE/4.3.5; x86_64; ; )
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
References: <20100224073342.15964.8863.stgit@localhost.localdomain> <20100224073822.15964.51065.stgit@localhost.localdomain> <20100224100654.GD18896@rakim.wolfsonmicro.main>
In-Reply-To: <20100224100654.GD18896@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002240216.08893.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wednesday 24 February 2010 02:06:55 am Mark Brown wrote:
> On Tue, Feb 23, 2010 at 11:38:23PM -0800, Dmitry Torokhov wrote:
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> >  	.driver		= {
> >  		.name	= "max1586",
> > +		.owner	= THIS_MODULE,
> >  	},
> 
> Note that a large number of your patches introduce this change and none
> of them note it in the changelog...
> 

Thanks for reviewing the lot.

Yes, I quite often list only most important changes in the log, and just
throw stuff like this in because I prefer to work on driver by driver
basis and splitting everything up produce twice as many patches. I will
try to be more detailed in my future submissions. 

-- 
Dmitry
