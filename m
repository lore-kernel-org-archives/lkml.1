Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXBSA3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXBSA3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXBSA3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:29:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34413 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbXBSA3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:29:21 -0500
Date: Sun, 18 Feb 2007 16:29:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm2: compilation fix
Message-Id: <20070218162917.602153af.akpm@linux-foundation.org>
In-Reply-To: <200702190033.26285.rjw@sisk.pl>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	<200702190033.26285.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007 00:33:26 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > 
> > Will appear later at
> > 
> >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> 
> I think something like this is generally necessary:
> 
> ---
>  drivers/pci/quirks.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.20-mm2/drivers/pci/quirks.c
> ===================================================================
> --- linux-2.6.20-mm2.orig/drivers/pci/quirks.c
> +++ linux-2.6.20-mm2/drivers/pci/quirks.c
> @@ -21,6 +21,7 @@
>  #include <linux/init.h>
>  #include <linux/delay.h>
>  #include <linux/acpi.h>
> +#include <asm/apicdef.h>
>  #include "pci.h"
>  
>  /* The Mellanox Tavor device gives false positive parity errors

Will break all non-x86.

What are we trying to fix here?
