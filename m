Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbZBYQJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbZBYQJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZBYQJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:09:04 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34407 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752675AbZBYQJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:09:03 -0500
Date: Wed, 25 Feb 2009 17:08:54 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Frank Seidel <frank@f-seidel.de>
cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
In-Reply-To: <alpine.LRH.2.00.0902251657431.15476@vixen.sonytel.be>
Message-ID: <alpine.LRH.2.00.0902251706580.15476@vixen.sonytel.be>
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de> <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be> <49A56A2B.4040305@f-seidel.de> <alpine.LRH.2.00.0902251657431.15476@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Geert Uytterhoeven wrote:
> On Wed, 25 Feb 2009, Frank Seidel wrote:
> > Geert Uytterhoeven wrote:
> > > BTW, why are you using printk(KERN_INFO "..."), and not pr_info("...")?
> > 
> > Without special reason. Is pr_info preferred?
> 
> It's shorter.
> 
> Especially `pr_err' fits in the space of `printk', so you don't have to split
> lines that become to long due to adding the KERN_*.

I sent it out too soon...

Other advantages:
  - The pr_*() calls use pr_fmt(), so you can set default prefixes (like
    __FILE__, __function, __LINE) at one place at the top of your driver source
    file.
  - pr_debug() is automatically left out if DEBUG is not defined (unless
    CONFIG_DYNAMIC_PRINTK_DEBUG is set).

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
