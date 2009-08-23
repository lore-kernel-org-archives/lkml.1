Return-Path: <linux-kernel-owner+w=401wt.eu-S933378AbZHWAHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbZHWAHD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 20:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933333AbZHWAHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 20:07:01 -0400
Received: from bu3sch.de ([62.75.166.246]:50462 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265AbZHWAHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 20:07:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Peter Huewe <PeterHuewe@gmx.de>
Subject: Re: [PATCH] gpio: adding __init/__exit macros in drivers/gpio/bt8xxgpio.c
Date: Sun, 23 Aug 2009 02:06:57 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <trivial@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <200908230201.10471.PeterHuewe@gmx.de>
In-Reply-To: <200908230201.10471.PeterHuewe@gmx.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908230206.57937.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 August 2009 02:01:10 Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macro to the init/exit functions of
> drivers/gpio/bt8xxgpio.c
> 
> Michael, Kay or Greg, please have a look at the small patch and either pull it
> through your tree, or please ack' it so Jiri can pull it through the trivial
> tree.
> 
> linux version 2.6.31-rc7 - linus git tree, So 23. Aug 01:38:43 CEST 2009
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Michael Buesch <mb@bu3sch.de>

> ---
> diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
> index 984b587..5590414 100644
> --- a/drivers/gpio/bt8xxgpio.c
> +++ b/drivers/gpio/bt8xxgpio.c
> @@ -331,13 +331,13 @@ static struct pci_driver bt8xxgpio_pci_driver = {
>  	.resume		= bt8xxgpio_resume,
>  };
>  
> -static int bt8xxgpio_init(void)
> +static int __init bt8xxgpio_init(void)
>  {
>  	return pci_register_driver(&bt8xxgpio_pci_driver);
>  }
>  module_init(bt8xxgpio_init)
>  
> -static void bt8xxgpio_exit(void)
> +static void __exit bt8xxgpio_exit(void)
>  {
>  	pci_unregister_driver(&bt8xxgpio_pci_driver);
>  }
> 
> 



-- 
Greetings, Michael.
