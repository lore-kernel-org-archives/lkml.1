Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbXGOJx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbXGOJx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXGOJxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:53:49 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55332 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864AbXGOJxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:53:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=RtXzipudLJPfapnKg8u+l2NPU5THDMqCsfHIhMrhTGXu8Qmf7aQ0XJN82vbSkOPunCUmfhGhCSqdpl/BVN27XU6SC/8ru/fshT8KYNX7qrs0XrLK/2TTqT8Af0B7730r;
Message-ID: <4699EEA9.6070709@simon.arlott.org.uk>
Date: Sun, 15 Jul 2007 10:53:45 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
References: <1184489571313-git-send-email-crquan@gmail.com>
In-Reply-To: <1184489571313-git-send-email-crquan@gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/07 09:52, Denis Cheng wrote:
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  drivers/net/wireless/wavelan.c |  806 ++++++++++++++++++----------------------
>  1 files changed, 369 insertions(+), 437 deletions(-)

Do people ever check what Lindent does?

> -	} else if (base_addr > 0x100) { /* Check a single specified location. */
> +	} else if (base_addr > 0x100) {	/* Check a single specified location. */

What is Lit doing here?! It's changed "{<space>/*" to "{<tab>/*"...


> -	} else { /* Scan all possible addresses of the WaveLAN hardware. */
> +	} else {		/* Scan all possible addresses of the WaveLAN hardware. */

And again... with two tabs for maximum unreadability. That line is now
90 characters long instead of 75.


> -				       "%s: <-wavelan_probe()\n",
> -				       dev->name);
> +				       "%s: <-wavelan_probe()\n", dev->name);

There are spaces in that line after the tabs...


> -out1:
> +      out1:

NAK: A perfectly valid non-indented label is now indented by 6 spaces.


> -out:
> +      out:

And again.


> -		       dev->name, (unsigned int) dev);
> +		       dev->name, (unsigned int)dev);

Those spaces after the tabs have been ignored...

-- 
Simon Arlott
