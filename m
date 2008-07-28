Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYG1I2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYG1I2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYG1I2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:28:17 -0400
Received: from isilmar.linta.de ([213.133.102.198]:38213 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751223AbYG1I2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:28:16 -0400
Date: Mon, 28 Jul 2008 10:28:14 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, dahinds@users.sourceforge.net,
       becker@scyld.com, x-csrdh@jcu.edu.au, erik@vt.edu,
       Jeff Garzik <jeff@garzik.org>, netdev <netdev@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] smc91c92_cs: use request_firmware
Message-ID: <20080728082814.GA4708@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Jaswinder Singh <jaswinder@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, dahinds@users.sourceforge.net,
	becker@scyld.com, x-csrdh@jcu.edu.au, erik@vt.edu,
	Jeff Garzik <jeff@garzik.org>, netdev <netdev@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>
References: <1217170341.3537.9.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217170341.3537.9.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 27, 2008 at 08:22:21PM +0530, Jaswinder Singh wrote:
> +static int osi_load_firmware(struct pcmcia_device *link)
> +{
> +	struct platform_device *pdev;
> +	const struct firmware *fw;
> +	const char fw_name[] = "ositech/Xilinx7OD.bin"; 
> +	int i, err;
> + 
> +	pdev = platform_device_register_simple("ositech", 0, NULL, 0);

Why do we need a platform_device here? Can't we just use the pcmcia device
(so &link->dev) here?

Thanks,
	Dominik
