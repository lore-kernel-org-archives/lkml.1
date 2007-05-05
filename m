Return-Path: <linux-kernel-owner+w=401wt.eu-S933753AbXEERTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbXEERTC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933766AbXEERTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:19:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:18154 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933753AbXEERTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RVyDXTAkR2dUzqsvyz5Dhvj0CRQ9k8M+88aNCPIYedJeHxoOsGtdepWp/gBi/3xQgWIDh1UdZ+vqvUU9POEApHCj00lW3yZCnRgiYNMXuL2V/J5DMc4LmpaaKP3kM6Qp4x+poPO2i9Wq/hYAGD4Aig8AMhxDyu9JhVq7zNE+HnM=
Message-ID: <463CBC57.5000303@googlemail.com>
Date: Sat, 05 May 2007 19:18:15 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.21-mm1
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <84144f020705050336p5988f21fv9b7cd628c0ef6c87@mail.gmail.com>
In-Reply-To: <84144f020705050336p5988f21fv9b7cd628c0ef6c87@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 5/5/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>   
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
>>     
>
> Someone broke UML.
>
>   

I guess it is x86_64-mm-i386-verify-cpu.patch.


> $ make ARCH=um defconfig
> $ make
>
> [snip]
>
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-um
>   CC      arch/um/kernel/asm-offsets.s
> In file included from include/asm/cpufeature.h:4,
>                  from include/asm/arch/system.h:6,
>                  from include/asm/system-generic.h:4,
>                  from include/asm/system.h:4,
>                  from include/linux/spinlock.h:57,
>                  from include/linux/capability.h:73,
>                  from include/linux/sched.h:46,
>                  from arch/um/include/sysdep/kernel-offsets.h:2,
>                  from arch/um/kernel/asm-offsets.c:1:
> include/asm/arch/cpufeature.h:13:35: error: asm/required-features.h:
> No such file or directory
> make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
>   

Gabriel

