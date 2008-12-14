Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbYLNWKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbYLNWKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYLNWKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:10:34 -0500
Received: from mail.openmoko.org ([88.198.124.205]:58844 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYLNWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:10:34 -0500
Date: Mon, 15 Dec 2008 03:40:19 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Green <andy@openmoko.com>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 5/7] power_supply: PCF50633 battery charger driver
Message-ID: <20081214221018.GB2741@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110323.3307.84154.stgit@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214110323.3307.84154.stgit@cff.thadambail>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 04:33:23PM +0530, Balaji Rao wrote:
> +
> +static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
> +{
> +	struct pcf50633 *pcf;
> +
> +	pcf = platform_get_drvdata(pdev);
> +
> +	/* Remove IRQ handlers */
> +	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
> +		pcf->irq_handler[mbc_irq_handlers[i]] = NULL;
> +
> +	return 0;
> +}
> +

Whoops! 'i not declared'. Oh., These last minute changes..

Will wait for more comments before sending a fixed version.

	- Balaji
> 
