Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZJZHxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZJZHxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZJZHxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:53:44 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36156 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZJZHxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UdUZHF4pIKgG5jV8AyOzWZoOeNy/juH3DA6JL9zSNhNqzEHvFDkMIs1j0v1R8buLhv
         5SVuPQMIRQg5sNsiNqT1wHCown2X7HuVNG8snvpVgTFoiGB6dkljEclrXDTAphGX7M9g
         K53/+zsAFMtA6+CfFLxe7vpjPw7vuYyw7Ue7Q=
MIME-Version: 1.0
In-Reply-To: <a8e1da0910260050y527bdbcbt4171ad6d868fcb29@mail.gmail.com>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
	 <a8e1da0910260050y527bdbcbt4171ad6d868fcb29@mail.gmail.com>
Date: Mon, 26 Oct 2009 15:53:47 +0800
Message-ID: <a8e1da0910260053r245ee675yca4dc984303187df@mail.gmail.com>
Subject: Re: linux-next: Tree for October 26
From: Dave Young <hidave.darkstar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 3:50 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi,
>
> build fails with ghash ghash-clmulni-intel_asm.S:

It is a x86_32 laptop


>
>  AS      arch/x86/crypto/ghash-clmulni-intel_asm.o
> arch/x86/crypto/ghash-clmulni-intel_asm.S: Assembler messages:
> arch/x86/crypto/ghash-clmulni-intel_asm.S:100: Error: bad register name `%rdi)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:101: Error: bad register name `%rsi)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:106: Error: bad register name `%rdi)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:114: Error: bad register name `%rdx'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:117: Error: bad register name `%rdi)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:118: Error: bad register name `%rcx)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:122: Error: bad register name `%rsi)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:126: Error: bad register name `%rdx'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:127: Error: bad register name `%rsi'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:128: Error: bad register name `%rdx'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:131: Error: bad register name `%rdi)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:142: Error: bad register name `%rsi)'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:156: Error: bad register name `%rdi)'
> make[2]: *** [arch/x86/crypto/ghash-clmulni-intel_asm.o] Error 1
> make[1]: *** [arch/x86/crypto] Error 2
> make: *** [arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
>
> cc herbert & huang ying
>
> --
> Regards
> dave
>



-- 
Regards
dave
