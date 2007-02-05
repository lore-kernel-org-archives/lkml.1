Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbXBENGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbXBENGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXBENGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:06:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:24277 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbXBENGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:06:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=InsPaBJtGm3jf0ad3op75puKoMkMq17Fs6xxmKER01yLVW8S3aZz710bvGWn7r/DGSMxJ5pbu6jXtyUdIGDhbhwwhM/Et9EmqhwVRphIvq0ZuixYIQkPPUzXbMtEBrkZodzMkvX6jkXP500R7HKZPrhfu58mE/0qX4o0wzFkuKE=
Message-ID: <625fc13d0702050506q11b971e3j9345b81c651ed232@mail.gmail.com>
Date: Mon, 5 Feb 2007 07:06:18 -0600
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070205084523.GA21858@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Ingo Molnar <mingo@elte.hu> wrote:
> Subject: [patch] MTD: fix DOC2000/2001/2001PLUS build error
> From: Ingo Molnar <mingo@elte.hu>
>
> The very first "make ARCH=i386 randconfig" gave this build error:
>
>     LD      vmlinux
>   drivers/built-in.o: In function `cafe_nand_remove':
>   cafe.c:(.text+0x19277a): undefined reference to `nand_release'
>   drivers/built-in.o: In function `cafe_nand_cmdfunc':
>   cafe.c:(.text+0x193036): undefined reference to `nand_wait_ready'
>   drivers/built-in.o: In function `cafe_nand_probe':
>   cafe.c:(.text+0x19359e): undefined reference to `nand_scan_ident'
>   cafe.c:(.text+0x193658): undefined reference to `nand_scan_tail'
>   distcc[1703] ERROR: compile (null) on localhost failed
>   make: *** [vmlinux] Error 1
>
> which i suspect was a side-effect of the late and optimistic MTD merge.
>
> but hey, we always knew Linux was better at offense than at defense, and
> good offense is what wins the game in the end, as the Bears had to find
> out the hard way ;-)
>
> so here's the fix for the 3 affected MTD drivers: DOC2000, DOC2001 and
> DOC2001PLUS.

Erm... from your output above, cafe.c is completely separate from the
DOC drivers.  Does this also need a fix, or...

David?

josh
