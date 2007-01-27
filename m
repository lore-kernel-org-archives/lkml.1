Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbXA0PFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbXA0PFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 10:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXA0PFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 10:05:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:50471 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXA0PFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 10:05:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=FItPM8MJ/UX54VDXuLhoHI6vWHjXYu32WsYCIhI56U+9WrlJ/EVJnIBBH3XnZcFme/hjoTVrEI0eXpHlZtbjjWX8bHiI3lLVnvK5T9sawQYPYAkeCAa5bJaHReneOA6kdy7/xCpVf2qLIFBb99xZxF5krVsiWWa5z9O2VAFeejA=
Message-ID: <45BB6A2F.8090401@googlemail.com>
Date: Sat, 27 Jan 2007 16:05:19 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@osdl.org napisał(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 

fs/ecryptfs/crypto.c: In function ‘ecryptfs_init_crypt_ctx’:
fs/ecryptfs/crypto.c:831: error: ‘CRYPTO_TFM_MODE_CBC’ undeclared (first use in this function)
fs/ecryptfs/crypto.c:831: error: (Each undeclared identifier is reported only once
fs/ecryptfs/crypto.c:831: error: for each function it appears in.)
make[2]: *** [fs/ecryptfs/crypto.o] Błąd 1
make[1]: *** [fs/ecryptfs] Błąd 2
make: *** [fs] Błąd 2

git-cryptodev.patch removes CRYPTO_TFM_MODE_CBC but it is still defined as ECRYPTFS_DEFAULT_CHAINING_MODE
in fs/ecryptfs/ecryptfs_kernel.h

What should be a new ECRYPTFS_DEFAULT_CHAINING_MODE ?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
