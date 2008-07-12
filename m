Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYGLRrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYGLRrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 13:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYGLRqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 13:46:55 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:60419 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYGLRqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 13:46:54 -0400
Subject: Re: [tpmdd-devel] Patch for Broadcom TPM TIS device HID
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eledisez <eledisez@grounation.org>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080711121646.cafaef2c.akpm@linux-foundation.org>
References: <2d97a3960807050312w76bde4c7hadeebb8a36aae761@mail.gmail.com>
	 <1215640191.25273.45.camel@blackbox>
	 <379cac7442a57a702f75cb2194dee9eb@localhost>
	 <1215650063.25273.77.camel@blackbox>
	 <20080711121646.cafaef2c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 12 Jul 2008 14:44:14 -0300
Message-Id: <1215884655.16230.42.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-11 at 12:16 -0700, Andrew Morton wrote: 
> On Wed, 09 Jul 2008 21:34:23 -0300 Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:
> 
> > This depends on patch posted with "[PATCH] tpm: add Intel TPM TIS device HID" subject.
> > 
> > From: LE DISEZ Erwan <eledisez@grounation.org>
> > Subject: add Broadcom TPM TIS device HID
> > 
> > 	Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> > ---
> >  drivers/char/tpm/tpm_tis.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > index c7a977b..ed1879c 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -622,6 +622,7 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
> >  	{"ATM1200", 0},		/* Atmel */
> >  	{"IFX0102", 0},		/* Infineon */
> >  	{"BCM0101", 0},		/* Broadcom */
> > +	{"BCM0102", 0},		/* Broadcom */
> >  	{"NSC1200", 0},		/* National */
> >  	{"ICO0102", 0},		/* Intel */
> >  	/* Add new here */
> 
> Thanks.  I'll see if we can squeeze this into 2.6.26.
> 
> I'm a bit confused over who wrote the patch?  Your changelog implies it
> was LE DISEZ Erwan <eledisez@grounation.org>.  Is that correct?

﻿Yes, it was him, I just added the Signed-off-by that he didn't and made it apply
cleanly after "[PATCH] tpm: add Intel TPM TIS device HID".

> 
> Also: Debora and Rajiv, could we please get your email addresses
> into ./MAINTAINERS?  At present all we have is
> 
> TPM DEVICE DRIVER
> P:     Debora Velarde
> P:     Rajiv Andrade
> M:      tpmdd-devel@lists.sourceforge.net
> W:      http://tpmdd.sourceforge.net
> P:      Marcel Selhorst
> M:      tpm@selhorst.net
> W:      http://www.prosec.rub.de/tpm/
> L:      tpmdd-devel@lists.sourceforge.net
> S:      Maintained

Sure! 
> 
> (pls fix the whitespace there too!)

My fault. I'd already submitted a patch correcting this, but I'm going to submit a new one with both fixes.

Thanks

