Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYGHUE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYGHUE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGHUEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:04:20 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:45217 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbYGHUEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:04:20 -0400
To: kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
References: <20080708190427.GA28899@phobos.i.cabal.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 Jul 2008 22:04:17 +0200
In-Reply-To: <20080708190427.GA28899@phobos.i.cabal.ca> (Kyle McMartin's message of "Tue\, 8 Jul 2008 15\:04\:27 -0400")
Message-ID: <m3myksf8hq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kmcmartin@redhat.com> writes:

> --- a/drivers/crypto/padlock-aes.c
> +++ b/drivers/crypto/padlock-aes.c
> @@ -384,6 +384,9 @@ static int __init padlock_init(void)
>  {
>  	int ret;
>  
> +	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR))
> +		return -ENODEV;
> +

BTW C has "!=" operator, may be useful.
-- 
Krzysztof Halasa
