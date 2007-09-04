Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbXIDRwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbXIDRwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 13:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbXIDRwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 13:52:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:48712 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbXIDRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 13:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KRbgmbKltAYiBnW+6F8LTOfFp36tcXa8fm6ckAGURNcmRAfj6jVcJ0sviwemGjZvatgG51IfWaYsXmrGN5RawLgBjIhANJe+0NwpAa9JFgPPB1irBYrn+FnnuWqdXW+qLzwZtbdL012a3OjwBv929p4KxP+NYs9rWuoAcsHWX8A=
Message-ID: <46DD9B8C.2060400@gmail.com>
Date: Tue, 04 Sep 2007 19:53:16 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1 net bitops compile error
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070902091416.GJ16016@stusta.de>
In-Reply-To: <20070902091416.GJ16016@stusta.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk napsal(a):
> defconfig fails with the following error on parisc:
> 
> <--  snip  -->
> 
> ...
>   CC      net/core/gen_estimator.o
> In file included from include2/asm/bitops.h:111,
>                  from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/net/core/gen_estimator.c:18:
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/asm-generic/bitops/non-atomic.h: 
> In function '__set_bit':
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/asm-generic/bitops/non-atomic.h:17: 
> error: implicit declaration of function 'BIT_MASK'
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/asm-generic/bitops/non-atomic.h:18: 
> error: implicit declaration of function 'BIT_WORD'
> make[3]: *** [net/core/gen_estimator.o] Error 1
> 
> <--  snip  -->
> 
> Either #include <asm/bitops.h> must become forbidden and #error or the 
> move of the #define's to include/linux/bitops.h reverted.

Just to let you know, that I'm working on the former.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
