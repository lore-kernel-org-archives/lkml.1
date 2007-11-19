Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbXKSBuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbXKSBuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 20:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXKSBuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 20:50:04 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2308 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751989AbXKSBuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 20:50:02 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: lkml@tlinx.org (Linda Walsh)
Subject: Re: ConfigQ? arch=i368; AES (generic v. i586)
Cc: linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <4740CA6D.9050507@tlinx.org>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Itvlg-0000Ar-00@gondolin.me.apana.org.au>
Date: Mon, 19 Nov 2007 09:49:44 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh <lkml@tlinx.org> wrote:
> There are two options for AES cipher algorithms under
> the Cryptographic API.  They read:
> _ AES Cipher algorithms
> _ AES Cipher algorithms (i586)
> ---
> 
> I assume(?) the i586 is for pentiums of some nature -- but is
> that any machine pentium(i586) or "newer"(686, P4, Core2, Centrino?).

It's optimised for Pentium and above but should work even on
a 386.

> If both options are selected (mod or compiled in), will the
> loading of the AES cipher automatically select the better choice?

Yes.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
