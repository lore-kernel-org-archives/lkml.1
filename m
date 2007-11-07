Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXKGNLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXKGNLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbXKGNK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:10:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50446 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754083AbXKGNK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:10:57 -0500
Date: Wed, 7 Nov 2007 13:11:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Fernando Luis =?UTF-8?B?VsOhenF1ZXo=?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -libata] nv_hardreset: update dangling reference to
 bugzilla entry
Message-ID: <20071107131111.74557c0c@the-village.bc.nu>
In-Reply-To: <1194420829.28494.9.camel@sebastian.kern.oss.ntt.co.jp>
References: <1194420829.28494.9.camel@sebastian.kern.oss.ntt.co.jp>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2007 16:33:49 +0900
Fernando Luis Vázquez Cao  <fernando@oss.ntt.co.jp> wrote:

> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.24-rc2-orig/drivers/ata/sata_nv.c linux-2.6.24-rc2/drivers/ata/sata_nv.c
> --- linux-2.6.24-rc2-orig/drivers/ata/sata_nv.c	2007-11-07 10:28:41.000000000 +0900
> +++ linux-2.6.24-rc2/drivers/ata/sata_nv.c	2007-11-07 16:29:21.000000000 +0900
> @@ -1629,7 +1629,7 @@ static int nv_hardreset(struct ata_link 
>  
>  	/* SATA hardreset fails to retrieve proper device signature on
>  	 * some controllers.  Don't classify on hardreset.  For more
> -	 * info, see http://bugme.osdl.org/show_bug.cgi?id=3352
> +	 * info, see http://bugzilla.kernel.org/show_bug.cgi?id=3352
>  	 */
>  	return sata_std_hardreset(link, &dummy, deadline);

Acked-by: Alan Cox <alan@redhat.com>
