Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbXGLXxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbXGLXxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbXGLXxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:53:38 -0400
Received: from smtp27.orange.fr ([80.12.242.96]:8231 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbXGLXxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:53:37 -0400
X-Greylist: delayed 3355 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 19:53:37 EDT
X-ME-UUID: 20070712223020202.316E11C12411@mwinf2704.orange.fr
Date: Fri, 13 Jul 2007 01:30:19 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC: removing DONGLE_OLD drivers?
Message-ID: <20070712223018.GA3576@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <20070709172539.GF3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709172539.GF3492@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon, Jul 09, 2007 at 07:25:39PM +0200, Adrian Bunk wrote:
> With one exception, all DONGLE_OLD drivers have newer counterparts.
> 
> The DONGLE_OLD drivers depend on BROKEN_ON_SMP which e.g. implies that 
> the many distributions shipping only SMP-kernels will never offer them.
> 
> The one exception is a driver for the Cirrus Logic EDB-7211 evaluation 
> board that itself is out of production for some years.
> 
> Can we remove these old drivers or is there a good reason for keeping 
> them?
I didn't notice the ep7211 is only using the old dongle API.
I'll convert it to the new one, and then we can start looking at getting
rid of the old drivers.

Cheers,
Samuel.



> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

