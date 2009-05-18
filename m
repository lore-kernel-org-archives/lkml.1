Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZERHRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZERHRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbZERHQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:16:53 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51249 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755877AbZERHQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:16:51 -0400
Date: Mon, 18 May 2009 09:16:49 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-crypto@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: compress - Return produced bytes in
 crypto_{,de}compress_{update,final}()
In-Reply-To: <alpine.LRH.2.00.0905111731490.302@vixen.sonytel.be>
Message-ID: <alpine.LRH.2.00.0905180915430.16754@vixen.sonytel.be>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
 <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be> <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be>
 <alpine.LRH.2.00.0905111731490.302@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Herbert,

On Mon, 11 May 2009, Geert Uytterhoeven wrote:
> If crypto_{,de}compress_{update,final}() succeed, return the actual number of
> bytes produced instead of zero, so their users don't have to calculate that
> theirselves.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
> As we're already at 2.6.30-rc5, I do not want to delay any longer this API
> change for a new module introduced for 2.6.30.
> 
> Herbert, please apply for 2.6.30.
> Thanks!

As I just saw your pull request for Linus, which didn't include this change,
I'm wondering if you plan to apply it for 2.6.30?

Thanks again!

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
