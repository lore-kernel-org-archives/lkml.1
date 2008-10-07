Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYJGVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYJGVDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYJGVDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:03:23 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:38837 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbYJGVDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:03:22 -0400
Date: Tue, 7 Oct 2008 23:04:58 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: djwong@us.ibm.com
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>,
       linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] matroxfb: Support G200eV chip
Message-Id: <20081007230458.286e187a.krzysztof.h1@poczta.fm>
In-Reply-To: <20081002002136.GJ10750@tree.beaverton.ibm.com>
References: <20081002002136.GJ10750@tree.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: fae2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 17:21:37 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Support the Matrox G200eV chip, based on timings that I found in the
> X.org matrox driver.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>



>  drivers/video/matrox/matroxfb_base.c |    9 +++++++++
>  include/linux/pci_ids.h              |    1 +
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
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

----------------------------------------------------------------------
Dzwon taniej na zagraniczne komorki!
Sprawdz >> http://link.interia.pl/f1f26 

