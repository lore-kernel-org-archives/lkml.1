Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYESWD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYESWD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764724AbYESWCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:02:44 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18360 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbYESWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:02:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] pnp: remove printk() with outdated version
Date: Mon, 19 May 2008 16:02:46 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       Adam M Belay <abelay@mit.edu>, Adam Belay <ambx1@neo.rr.com>
References: <20080519215419.GI17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519215419.GI17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191602.46460.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 03:54:19 pm Adrian Bunk wrote:
> There's no point in printing some ancient version number forever.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Adam's the maintainer, so you really should ask him (cc'd).
Personally, I agree that it isn't really useful anymore.

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
>  
> 
> 


