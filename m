Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbXGaTrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbXGaTrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXGaTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:47:27 -0400
Received: from khc.piap.pl ([195.187.100.11]:34177 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbXGaTr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:47:26 -0400
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 28] drivers/net/wan/hdlc_fr.c: kmalloc + memset conversion to kzalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707311949.52337.m.kozlowski@tuxland.pl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 31 Jul 2007 21:47:21 +0200
In-Reply-To: <200707311949.52337.m.kozlowski@tuxland.pl> (Mariusz Kozlowski's message of "Tue, 31 Jul 2007 19:49:52 +0200")
Message-ID: <m34pjkqrsm.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski <m.kozlowski@tuxland.pl> writes:

> +++ linux-2.6.23-rc1-mm1-b/drivers/net/wan/hdlc_fr.c	2007-07-30 00:25:40.000000000 +0200
> @@ -212,14 +212,13 @@ static pvc_device* add_pvc(struct net_de
>  		pvc_p = &(*pvc_p)->next;
>  	}
>
> -	pvc = kmalloc(sizeof(pvc_device), GFP_ATOMIC);
> +	pvc = kzalloc(sizeof(pvc_device), GFP_ATOMIC);
>  #ifdef DEBUG_PVC
>  	printk(KERN_DEBUG "add_pvc: allocated pvc %p, frad %p\n", pvc, dev);
>  #endif
>  	if (!pvc)
>  		return NULL;
>
> -	memset(pvc, 0, sizeof(pvc_device));

Looks good, thanks.
-- 
Krzysztof Halasa
