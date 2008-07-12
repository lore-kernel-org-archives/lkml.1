Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYGLNeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYGLNeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 09:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYGLNe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 09:34:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35290 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752551AbYGLNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 09:34:29 -0400
Subject: Re: [PATCH 1/2] regulator: TI bq24022 Li-Ion Charger driver
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20080711121638.3710c1ad.akpm@linux-foundation.org>
References: <1215716683.17490.29.camel@localhost.localdomain>
	 <20080711121638.3710c1ad.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 14:34:26 +0100
Message-Id: <1215869666.6634.64.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 12:16 -0700, Andrew Morton wrote:
> On Thu, 10 Jul 2008 21:04:43 +0200 Philipp Zabel <philipp.zabel@gmail.com> wrote:
> 
> > +/**
> > + *bq24022_mach_info - platform data for bq24022
> > + *@gpio_nce: GPIO line connected to the nCE pin,
> > + *           used to enable / disable charging.
> > + *@gpio_iset2: GPIO line connected to the ISET2 pin,
> > + *             used to limit charging current to 100 mA / 500 mA.
> > + */
> 
> We normally have a space after the "*" in kerneldoc comments (some
> weird people use a tab and waste space).
> 
> I don't know whether the kerneldoc processors will correctly handle
> the above.  I guess I'll fix it so we don't find out.
> 
> Also, I _think_ that kerneldoc will barf over the multi-line parameter
> descriptions.  I'll join those lines.
> 
> --- a/include/linux/regulator/bq24022.h~regulator-ti-bq24022-li-ion-charger-driver-fix
> +++ a/include/linux/regulator/bq24022.h
> @@ -11,11 +11,9 @@
>   */
>  
>  /**
> - *bq24022_mach_info - platform data for bq24022
> - *@gpio_nce: GPIO line connected to the nCE pin,
> - *           used to enable / disable charging.
> - *@gpio_iset2: GPIO line connected to the ISET2 pin,
> - *             used to limit charging current to 100 mA / 500 mA.
> + * bq24022_mach_info - platform data for bq24022
> + * @gpio_nce: GPIO line connected to the nCE pin, used to enable / disable charging
> + * @gpio_iset2: GPIO line connected to the ISET2 pin, used to limit charging current to 100 mA / 500 mA
>   */
>  struct bq24022_mach_info {
>  	int gpio_nce;
> _


Applied (to regulator git).

Thanks

Liam

