Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYJBJ3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYJBJ3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbYJBJ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:29:39 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:35695 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYJBJ3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:29:39 -0400
Date: 02 Oct 2008 11:29:33 +0200
From: krzysztof.h1@poczta.fm
Subject: Re: [Linux-fbdev-devel] [PATCH] matroxfb: Support G200eV chip
To: "djwong@us.ibm.com" <djwong@us.ibm.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 83.17.101.58
X-Mailer: PSE
Message-Id: <20081002092933.2EFC4199B267@f14.poczta.interia.pl>
X-EMID: 9bd40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Support the Matrox G200eV chip, based on timings that I found in the
> X.org matrox driver.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 

Is the new chip requires some changes in handling (e.g. diffrent clock ranges/setting, etc)?
There is nothing about timings in the patch (aside 230MHz).

Kind regards,
Krzysztof


>  drivers/video/matrox/matroxfb_base.c |    9 +++++++++
>  include/linux/pci_ids.h              |    1 +
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/matrox/matroxfb_base.c
> b/drivers/video/matrox/matroxfb_base.c
> index c021362..8e7a275 100644
> --- a/drivers/video/matrox/matroxfb_base.c
> +++ b/drivers/video/matrox/matroxfb_base.c
> @@ -1453,6 +1453,13 @@ static struct board {
>  		MGA_G100,
>  		&vbG100,
>  		"MGA-G100 (AGP)"},
> +	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,	0xFF,
> +		0,			0,
> +		DEVF_G200,
> +		230000,
> +		MGA_G200,
> +		&vbG200,
> +		"MGA-G200eV (PCI)"},
>  	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,	0xFF,
>  		0,			0,
>  		DEVF_G200,
> @@ -2118,6 +2125,8 @@ static struct pci_device_id matroxfb_devices[] = {
>  		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
>  	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G100_AGP,
>  		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
> +	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,
> +		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
>  	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,
>  		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
>  	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_AGP,
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index f1624b3..6260fab 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -577,6 +577,7 @@
>  #define PCI_DEVICE_ID_MATROX_G200_PCI	0x0520
>  #define PCI_DEVICE_ID_MATROX_G200_AGP	0x0521
>  #define	PCI_DEVICE_ID_MATROX_G400	0x0525
> +#define	PCI_DEVICE_ID_MATROX_G200EV_PCI	0x0530
>  #define PCI_DEVICE_ID_MATROX_G550	0x2527
>  #define PCI_DEVICE_ID_MATROX_VIA	0x4536
>  
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's
> challenge
> Build the coolest Linux based applications with Moblin SDK & win great
> prizes
> Grand prize is a trip for two to an Open Source event anywhere in the
> world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Linux-fbdev-devel mailing list
> Linux-fbdev-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel
> 
> 


----------------------------------------------------------------------
Zapytaj o Milosc, Prace, Zdrowie, Rodzine ...
Sprawdz >> http://link.interia.pl/f1f27 


