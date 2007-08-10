Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbXHJFLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbXHJFLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 01:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXHJFLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 01:11:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:59370 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXHJFLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 01:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z0P+LMWlbI4GSfQgYyncuYKdoXAWUJeJd1rqjJPWu36YLAlYeP4nidXfYFSE4XPrXsxsbeLWJDTrsDRUrJ2WNMwi7Oxbh/qsc2g78fpjB9v1xur/g27v5jxbak7fUiFetMbUTVIrJEe4qZNcc15/nHO9x71yukWIMiIb2CuKmPY=
Message-ID: <86802c440708092211y513f5dd2rd27310b626a7f0c2@mail.gmail.com>
Date: Thu, 9 Aug 2007 22:11:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: EFI e820 map handling
Cc: "Huang, Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200708091206.37302.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708091206.37302.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Andi Kleen <ak@suse.de> wrote:
>
> Hallo,
>
> I thought a bit about the zero page problem. I really would prefer to not
> having it used in a boot loader right now because it's not extensible anymore
> when external users start (ab)using it.
>
> When I asked for separate EFI->e820 functions I was really thinking
> of the kernel to do the conversion; not the boot loader.
>
> Could you move that code into the kernel early boot code please?
> e.g. on x86-64 it could be in head64.c.  It could stuff the result
> into the zero page to pass it cleanly on without special cases later.
>
> On i386 a head32.c that runs before start_kernel() could be also
> introduced for this.
>
> As long as it's localized there it is fine.
>
> This would also allow to define new private e820 types and extend
> the string decoding in e820; so that dmesg will correctly contain
>
> EFI: ....
>
> instead of
>
> BIOS-e820: ...
>

How about elilo to load freebsd or opensolaris?

YH
