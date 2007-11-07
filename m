Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbXKGFVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbXKGFVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXKGFVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:21:12 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:41502 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXKGFVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:21:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e/q6Pxtqqf02xZX5bsbBJAKWaFOVH7Ajh5z7RS9iKseieZhffHIYi/X97z9Cwb5vTXNkzSEijrub/nrXcdbQDlZXKQeeg6fRynxwgKTOSkqztjH00pxjlEavPEi1YjitOWn87qeU/b6ijW2rjU7cCXg++Yy5yPw3+4T+NIJcvAY=
Message-ID: <cac476880711062121o33c83abdv1d5bb1ebc5c9feab@mail.gmail.com>
Date: Tue, 6 Nov 2007 21:21:10 -0800
From: "Josh Logan" <joshtlogan@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Ciaran McCreesh" <ciaran.mccreesh@blueyonder.co.uk>,
       "Edward Hsu" <edward_hsu@realtek.com.tw>, linux-kernel@vger.kernel.org
In-Reply-To: <20071101215348.GA17449@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029061532.5d10dfc6@snowcone>
	 <20071029083333.18a4dab7@the-village.bc.nu>
	 <4729FC36.3040000@gmail.com>
	 <20071101215348.GA17449@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tried this out and it works great.

Thanks!

Later, JOSH


On 11/1/07, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Josh Logan <joshtlogan@gmail.com> :
> [...]
> > I have had this board for a few months as well and I have needed to
> > patch the driver to use 0x0001 as well.
>
> Ok.
>
> Can people give the patch below a try before I submit it to Jeff ?
>
> From: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
> Date: Thu, 1 Nov 2007 22:48:15 +0100
> Subject: [PATCH] r8169: add PCI ID for the 8168 in the Abit Fatal1ty F-190HD motherboard
>
> Signed-off-by: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> Cc: Edward Hsu <edward_hsu@realtek.com.tw>
> ---
>  drivers/net/r8169.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index b94fa7e..702334e 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -171,6 +171,8 @@ static struct pci_device_id rtl8169_pci_tbl[] = {
>         { PCI_DEVICE(0x16ec,                    0x0116), 0, 0, RTL_CFG_0 },
>         { PCI_VENDOR_ID_LINKSYS,                0x1032,
>                 PCI_ANY_ID, 0x0024, 0, 0, RTL_CFG_0 },
> +       { 0x0001,                               0x8168,
> +               PCI_ANY_ID, 0x2410, 0, 0, RTL_CFG_2 },
>         {0,},
>  };
>
> --
> 1.5.3.3
>
>
