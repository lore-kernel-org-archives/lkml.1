Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbXFTX5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbXFTX5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXFTX5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:57:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45906 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938AbXFTX52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:57:28 -0400
Message-ID: <4679BEE4.6030107@garzik.org>
Date: Wed, 20 Jun 2007 19:57:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fix module_param mistake in it821x
References: <46797505.1030508@aknet.ru>
In-Reply-To: <46797505.1030508@aknet.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stas Sergeev wrote:
> Hello.
> 
> The attached patch fixes a trivial
> mistake in a MODULE_PARAM_DESC of pata_it821x
> driver. The parameter name in MODULE_PARAM_DESC
> should match the one in module_param_named.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> 
> 
> ------------------------------------------------------------------------
> 
> --- a/drivers/ata/pata_it821x.c	2007-04-27 12:46:35.000000000 +0400
> +++ b/drivers/ata/pata_it821x.c	2007-06-20 18:16:20.000000000 +0400
> @@ -828,7 +828,7 @@
>  
>  
>  module_param_named(noraid, it8212_noraid, int, S_IRUGO);
> -MODULE_PARM_DESC(it8212_noraid, "Force card into bypass mode");
> +MODULE_PARM_DESC(noraid, "Force card into bypass mode");

applied


