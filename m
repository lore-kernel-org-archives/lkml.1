Return-Path: <linux-kernel-owner+w=401wt.eu-S1765262AbXKTXw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765262AbXKTXw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762352AbXKTXwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:52:40 -0500
Received: from khc.piap.pl ([195.187.100.11]:47402 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764879AbXKTXwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:52:39 -0500
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 34/59] drivers/net/wan: Add missing "space"
References: <1195523331-15303-1-git-send-email-joe@perches.com>
	<1195523331-15303-17-git-send-email-joe@perches.com>
	<1195523331-15303-18-git-send-email-joe@perches.com>
	<1195523331-15303-19-git-send-email-joe@perches.com>
	<1195523331-15303-20-git-send-email-joe@perches.com>
	<1195523331-15303-21-git-send-email-joe@perches.com>
	<1195523331-15303-22-git-send-email-joe@perches.com>
	<1195523331-15303-23-git-send-email-joe@perches.com>
	<1195523331-15303-24-git-send-email-joe@perches.com>
	<1195523331-15303-25-git-send-email-joe@perches.com>
	<1195523331-15303-26-git-send-email-joe@perches.com>
	<1195523331-15303-27-git-send-email-joe@perches.com>
	<1195523331-15303-28-git-send-email-joe@perches.com>
	<1195523331-15303-29-git-send-email-joe@perches.com>
	<1195523331-15303-30-git-send-email-joe@perches.com>
	<1195523331-15303-31-git-send-email-joe@perches.com>
	<1195523331-15303-32-git-send-email-joe@perches.com>
	<1195523331-15303-33-git-send-email-joe@perches.com>
	<1195523331-15303-34-git-send-email-joe@perches.com>
	<ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
	<1195523331-15303-35-git-send-email-joe@perches.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 21 Nov 2007 00:52:36 +0100
In-Reply-To: <1195523331-15303-35-git-send-email-joe@perches.com> (Joe Perches's message of "Mon, 19 Nov 2007 17:48:26 -0800")
Message-ID: <m3lk8sv5iz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> --- a/drivers/net/wan/wanxl.c
> +++ b/drivers/net/wan/wanxl.c
> @@ -743,7 +743,7 @@ static int __devinit wanxl_pci_init_one(struct pci_dev *pdev,
>  	}while (time_after(timeout, jiffies));
>  
>  	if (!stat) {
> -		printk(KERN_WARNING "wanXL %s: timeout while initializing card"
> +		printk(KERN_WARNING "wanXL %s: timeout while initializing card "
>  		       "firmware\n", pci_name(pdev));
>  		wanxl_pci_remove_one(pdev);
>  		return -ENODEV;

Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
Thanks.
-- 
Krzysztof Halasa
