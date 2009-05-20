Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZETO4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZETO4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZETO4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:56:31 -0400
Received: from cet.com.ru ([195.178.208.66]:41939 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZETO4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:56:31 -0400
Date: Wed, 20 May 2009 18:56:23 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hifn_795x - fix __dev{init,exit} markings
Message-ID: <20090520145623.GA4147@ioremap.net>
References: <1242633110-16344-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242633110-16344-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike.

On Mon, May 18, 2009 at 03:51:50AM -0400, Mike Frysinger (vapier@gentoo.org) wrote:
> The remove member of the pci_driver hifn_pci_driver uses __devexit_p(),
> so the remove function itself should be marked with __devexit.  And where
> there be __devexit on the remove, so is there __devinit on the probe.
> 
> Similarly, the module_init/module_exit functions should be declared with
> plain __init/__exit markings, not the hotplug __dev{init,exit} ones.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Evgeniy Polyakov <zbr@ioremap.net>
> CC: Patrick McHardy <kaber@trash.net>

Looks good, thank you Mike.
Ack. Herbert, please apply.

-- 
	Evgeniy Polyakov
