Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbXBAR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbXBAR35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbXBAR35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:29:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43030 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbXBAR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:29:56 -0500
Date: Thu, 1 Feb 2007 18:28:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -rt]: mtd cafe: Use IRQF_SHARED
Message-ID: <20070201172836.GA28269@elte.hu>
References: <20070201143752.71fa569b@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070201143752.71fa569b@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4986]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br> wrote:

>  Ingo,
> 
>  I need the following fix to compile your -rt patch, otherwise I get:
> 
>   CC [M]  drivers/mtd/nand/cafe.o
> drivers/mtd/nand/cafe.c: In function ‘cafe_nand_probe’:
> drivers/mtd/nand/cafe.c:600: error: ‘SA_SHIRQ’ undeclared (first use in this function)
> drivers/mtd/nand/cafe.c:600: error: (Each undeclared identifier is reported only once
> drivers/mtd/nand/cafe.c:600: error: for each function it appears in.)

thanks, applied.

	Ingo
