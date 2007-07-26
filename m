Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbXGZXGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbXGZXGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXGZXGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:06:03 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:58613 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbXGZXGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:06:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=ho2tRkjndQ9PxCVx+cNO3nqvuaPNvNFjhe8XL3SQcWS76J4nTf9Bf8O/ZY334II+/zjKJQcmLYcnpTP855blZDWBEdzI9DdDtfhEr1S7ZM9v7bwJirwqgecHMMHAjD0Z;
Message-ID: <46A928D2.6030702@simon.arlott.org.uk>
Date: Fri, 27 Jul 2007 00:05:54 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: bjorn.helgaas@hp.com
Subject: Fwd: PNP: Lindent all source files
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone ever review what Lindent does? There's a fix up patch after this 
but it missed this at the very top of the patch and the labels.

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9dd78466c956ac4b4f38e12032dc4249ccf57ad1
> Commit:     9dd78466c956ac4b4f38e12032dc4249ccf57ad1
> Parent:     8ec3cf7d29aef773eee5bc6cd9b0fa4d3fb42480
> Author:     Bjorn Helgaas <bjorn.helgaas@hp.com>
> AuthorDate: Thu Jul 26 10:41:20 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Thu Jul 26 11:35:20 2007 -0700
> 
>     PNP: Lindent all source files
>     
> diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
> index dd6384b..a379a38 100644
> --- a/drivers/pnp/card.c
> +++ b/drivers/pnp/card.c
> @@ -13,26 +13,28 @@
> -					if (compare_pnp_id(dev->id, drv_id->devs[i].id)) {
> +					if (compare_pnp_id
> +					    (dev->id, drv_id->devs[i].id)) {

Leaving only the function name on a seperate line? How is that better?


> @@ -320,7 +330,7 @@ found:
>  
>  	return dev;
>  
> -err_out:
> +      err_out:
>  	dev->dev.driver = NULL;
>  	dev->card_link = NULL;
>  	return NULL;

Six spaces before a label that originally had no indentation?


The spaces it uses on lines after if (which happens all over the place) 
appear to go against CodingStyle's:
"Outside of comments, documentation and except in Kconfig, spaces are never
used for indentation, and the above example is deliberately broken."

-- 
Simon Arlott
