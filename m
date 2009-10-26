Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZJZHu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZJZHu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbZJZHu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:50:28 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59333 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZJZHu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dVityZuDInfkTXOfd3ZAHi6wa/34kKmtorTaQMAUO+vUzusMeDzIcVokqa4OKhi35Z
         1v1cFwgkiKQXxcwKAZShcW4KPsqWfwgeiisy3BWPQmgUD3v3tqCEXtKS/SO05rsLUzG3
         sa2+BCuiTUS4cN0YcnwoNodBrmK7uGDshs4xw=
MIME-Version: 1.0
In-Reply-To: <20091026172104.205f15af.sfr@canb.auug.org.au>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
Date: Mon, 26 Oct 2009 15:50:31 +0800
Message-ID: <a8e1da0910260050y527bdbcbt4171ad6d868fcb29@mail.gmail.com>
Subject: Re: linux-next: Tree for October 26
From: Dave Young <hidave.darkstar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

build fails with ghash ghash-clmulni-intel_asm.S:

  AS      arch/x86/crypto/ghash-clmulni-intel_asm.o
arch/x86/crypto/ghash-clmulni-intel_asm.S: Assembler messages:
arch/x86/crypto/ghash-clmulni-intel_asm.S:100: Error: bad register name `%rdi)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:101: Error: bad register name `%rsi)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:106: Error: bad register name `%rdi)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:114: Error: bad register name `%rdx'
arch/x86/crypto/ghash-clmulni-intel_asm.S:117: Error: bad register name `%rdi)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:118: Error: bad register name `%rcx)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:122: Error: bad register name `%rsi)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:126: Error: bad register name `%rdx'
arch/x86/crypto/ghash-clmulni-intel_asm.S:127: Error: bad register name `%rsi'
arch/x86/crypto/ghash-clmulni-intel_asm.S:128: Error: bad register name `%rdx'
arch/x86/crypto/ghash-clmulni-intel_asm.S:131: Error: bad register name `%rdi)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:142: Error: bad register name `%rsi)'
arch/x86/crypto/ghash-clmulni-intel_asm.S:156: Error: bad register name `%rdi)'
make[2]: *** [arch/x86/crypto/ghash-clmulni-intel_asm.o] Error 1
make[1]: *** [arch/x86/crypto] Error 2
make: *** [arch/x86] Error 2
make: *** Waiting for unfinished jobs....

cc herbert & huang ying

--
Regards
dave
