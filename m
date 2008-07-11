Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYGKTSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYGKTSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYGKTSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbYGKTSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:09 -0400
Date: Fri, 11 Jul 2008 12:16:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: eledisez <eledisez@grounation.org>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] Patch for Broadcom TPM TIS device HID
Message-Id: <20080711121646.cafaef2c.akpm@linux-foundation.org>
In-Reply-To: <1215650063.25273.77.camel@blackbox>
References: <2d97a3960807050312w76bde4c7hadeebb8a36aae761@mail.gmail.com>
	<1215640191.25273.45.camel@blackbox>
	<379cac7442a57a702f75cb2194dee9eb@localhost>
	<1215650063.25273.77.camel@blackbox>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 21:34:23 -0300 Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:

> This depends on patch posted with "[PATCH] tpm: add Intel TPM TIS device HID" subject.
> 
> From: LE DISEZ Erwan <eledisez@grounation.org>
> Subject: add Broadcom TPM TIS device HID
> 
> 	Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_tis.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index c7a977b..ed1879c 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -622,6 +622,7 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
>  	{"ATM1200", 0},		/* Atmel */
>  	{"IFX0102", 0},		/* Infineon */
>  	{"BCM0101", 0},		/* Broadcom */
> +	{"BCM0102", 0},		/* Broadcom */
>  	{"NSC1200", 0},		/* National */
>  	{"ICO0102", 0},		/* Intel */
>  	/* Add new here */

Thanks.  I'll see if we can squeeze this into 2.6.26.

I'm a bit confused over who wrote the patch?  Your changelog implies it
was LE DISEZ Erwan <eledisez@grounation.org>.  Is that correct?

Also: Debora and Rajiv, could we please get your email addresses
into ./MAINTAINERS?  At present all we have is

TPM DEVICE DRIVER
P:     Debora Velarde
P:     Rajiv Andrade
M:      tpmdd-devel@lists.sourceforge.net
W:      http://tpmdd.sourceforge.net
P:      Marcel Selhorst
M:      tpm@selhorst.net
W:      http://www.prosec.rub.de/tpm/
L:      tpmdd-devel@lists.sourceforge.net
S:      Maintained

(pls fix the whitespace there too!)
