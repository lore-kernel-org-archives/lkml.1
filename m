Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYHFVj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYHFVj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHFVjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:39:37 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55421 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYHFVjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:39:37 -0400
Message-ID: <489A19D1.9070507@keyaccess.nl>
Date: Wed, 06 Aug 2008 23:38:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam M Belay <abelay@MIT.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] pnp: remove printk() with outdated version
References: <20080806211023.GD1702@cs181140183.pp.htv.fi>
In-Reply-To: <20080806211023.GD1702@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-08-08 23:10, Adrian Bunk wrote:

> There's no point in printing some ancient version number forever.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by; Rene Herman <rene.herman@gmail.com>
> Acked-by; Bjorn Helgaas <bjorn.helgaas@hp.com>
> Acked-by; Adam M Belay <abelay@MIT.EDU>

semicolons... :-/

> ---
> 
> This patch has been sent on:
> - 20 May 2008
> 
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

Rene.
