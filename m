Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbZE0FQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbZE0FQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZE0FQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:16:42 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:51665 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757584AbZE0FQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:16:41 -0400
Date: Wed, 27 May 2009 15:16:36 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] crypto: hifn_795x - fix __dev{init,exit} markings
Message-ID: <20090527051635.GD7474@gondor.apana.org.au>
References: <1242633110-16344-1-git-send-email-vapier@gentoo.org> <20090520145623.GA4147@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520145623.GA4147@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 06:56:23PM +0400, Evgeniy Polyakov wrote:
> Hi Mike.
> 
> On Mon, May 18, 2009 at 03:51:50AM -0400, Mike Frysinger (vapier@gentoo.org) wrote:
> > The remove member of the pci_driver hifn_pci_driver uses __devexit_p(),
> > so the remove function itself should be marked with __devexit.  And where
> > there be __devexit on the remove, so is there __devinit on the probe.
> > 
> > Similarly, the module_init/module_exit functions should be declared with
> > plain __init/__exit markings, not the hotplug __dev{init,exit} ones.
> > 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > CC: Evgeniy Polyakov <zbr@ioremap.net>
> > CC: Patrick McHardy <kaber@trash.net>
> 
> Looks good, thank you Mike.
> Ack. Herbert, please apply.

Applied to cryptodev.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
