Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0BHKuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:50:52 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56273 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0BHKuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:50:51 -0500
Subject: Re: [PATCH 3/3] nozomi: Tidy up the PCI table
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, p.hardwick@option.com
In-Reply-To: <20100208100710.2794.73323.stgit@localhost.localdomain>
References: <20100208100642.2794.73225.stgit@localhost.localdomain>
	 <20100208100710.2794.73323.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 11:49:49 +0100
Message-ID: <1265626189.31341.260.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/char/nozomi.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
> index fac9157..86c9e64 100644
> --- a/drivers/char/nozomi.c
> +++ b/drivers/char/nozomi.c
> @@ -136,10 +136,6 @@ static int debug;
>  #define RECEIVE_BUF_MAX		4
>  
> 
> -/* Define all types of vendors and devices to support */
> -#define VENDOR1		0x1931	/* Vendor Option */
> -#define DEVICE1		0x000c	/* HSDPA card */
> -
>  #define R_IIR		0x0000	/* Interrupt Identity Register */
>  #define R_FCR		0x0000	/* Flow Control Register */
>  #define R_IER		0x0004	/* Interrupt Enable Register */
> @@ -407,7 +403,7 @@ struct buffer {
>  
>  /*    Global variables */
>  static const struct pci_device_id nozomi_pci_tbl[] __devinitconst = {
> -	{PCI_DEVICE(VENDOR1, DEVICE1)},
> +	{PCI_DEVICE(0x1931, 0x000c)},	/* Nozomi HSPDA */
>  	{},

that would be HSDPA actually.

Regards

Marcel


