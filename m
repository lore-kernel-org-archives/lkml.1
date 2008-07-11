Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYGKPHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYGKPHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYGKPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:07:05 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13156 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYGKPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:07:03 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y
Date: Fri, 11 Jul 2008 09:05:49 -0600
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
References: <20080711143648.19650.93895.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080711143648.19650.93895.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807110905.50123.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 8:36:48 am David Howells wrote:
> Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y as it's only
> accessed in that case.
>
> The PNP=n variant was added by patch
> 30d55e71a81b1f5a8136f191dc9f4c21f18e77e6.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

> ---
>
>  drivers/isdn/hisax/hisax_fcpcipnp.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
>
> diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c
> b/drivers/isdn/hisax/hisax_fcpcipnp.c index c0b4db2..1925118 100644
> --- a/drivers/isdn/hisax/hisax_fcpcipnp.c
> +++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
> @@ -974,8 +974,6 @@ static struct pnp_driver fcpnp_driver = {
>  	.remove		= __devexit_p(fcpnp_remove),
>  	.id_table	= fcpnp_ids,
>  };
> -#else
> -static struct pnp_driver fcpnp_driver;
>  #endif
>
>  static void __devexit fcpci_remove(struct pci_dev *pdev)


