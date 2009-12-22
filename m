Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZLVJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZLVJWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 04:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZLVJWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 04:22:18 -0500
Received: from mail.perches.com ([173.55.12.10]:1371 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZLVJWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 04:22:17 -0500
Subject: Re: [PATCH] MAINTAINERS: Fix entry for uwb to include
 subdirectories
From: Joe Perches <joe@perches.com>
To: Peter Huewe <peterhuewe@gmx.de>, David Vrabel <david.vrabel@csr.com>
Cc: Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1261472760-24854-1-git-send-email-peterhuewe@gmx.de>
References: <1261472760-24854-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 01:22:15 -0800
Message-ID: <1261473735.1895.22.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 10:05 +0100, Peter Huewe wrote:
> This little patch removes the asterisk wildcard, in order to get the uwb
> maintainer when using get_maintainer.pl on anyfiles in the
> subdirectories of uwb.

Is this correct?
Does David Vrabel maintain drivers/uwb/i1480/ ?

drivers/uwb/wlp/ is separately maintained
WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM

> Otherwise it get_maintainer.pl does not come up with a result

Sure it does:
$ ./scripts/get_maintainer.pl -f drivers/uwb/i1480
Jiri Kosina <jkosina@suse.cz>
David Vrabel <david.vrabel@csr.com>
Stephen Hemminger <shemminger@vyatta.com>
David S. Miller <davem@davemloft.net>
Nick Andrew <nick@nick-andrew.net>
linux-kernel@vger.kernel.org

> diff --git a/MAINTAINERS b/MAINTAINERS
> index e770069..fbcc8f9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5467,7 +5467,7 @@ ULTRA-WIDEBAND (UWB) SUBSYSTEM:
>  M:	David Vrabel <david.vrabel@csr.com>
>  L:	linux-usb@vger.kernel.org
>  S:	Supported
> -F:	drivers/uwb/*
> +F:	drivers/uwb/
>  F:	include/linux/uwb.h
>  F:	include/linux/uwb/



