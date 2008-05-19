Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbYESXWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbYESXWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbYESXV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:21:28 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:49011 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968AbYESXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:21:08 -0400
Message-ID: <4831FE30.4040203@keyaccess.nl>
Date: Tue, 20 May 2008 00:24:48 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Rene Herman <rene.herman@gmail.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] pnp: remove printk() with outdated version
References: <20080519215419.GI17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519215419.GI17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-05-08 23:54, Adrian Bunk wrote:

> There's no point in printing some ancient version number forever.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> acef517cfbe3cd741f8884311ef6fc2dfbeb1a4d diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
> index 20771b7..d924798 100644
> --- a/drivers/pnp/core.c
> +++ b/drivers/pnp/core.c
> @@ -209,7 +209,6 @@ void __pnp_remove_device(struct pnp_dev *dev)
>  
>  static int __init pnp_init(void)
>  {
> -	printk(KERN_INFO "Linux Plug and Play Support v0.97 (c) Adam Belay\n");
>  	return bus_register(&pnp_bus_type);
>  }

Acked-by; Rene Herman <rene.herman@gmail.com>

Rene.

