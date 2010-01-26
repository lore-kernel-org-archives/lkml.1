Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759Ab0AZJPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab0AZJPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709Ab0AZJPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:15:43 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:54935 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab0AZJPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f6fDcwLfHMJ6uvpaPMxm8H3GZfV9RXLkmxszqhouQn1A/wVN+maDKc55vfCFJARts9
         xPO2Ep5ZWT+s+DHAvaPLZPEjB3duTjM1qrSHFGrMNY5RIWGI49cGIr6qj/0oAMvlBZLS
         N4w9p/n15ekHvf1ztMein0Qs90gc5qtY9ZzhI=
MIME-Version: 1.0
In-Reply-To: <4B5EB223.60307@windriver.com>
References: <4B5E5D4F.50803@windriver.com>
	 <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com>
	 <4B5E9BE9.2030702@windriver.com>
	 <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com>
	 <4B5EB223.60307@windriver.com>
Date: Tue, 26 Jan 2010 17:15:40 +0800
Message-ID: <2375c9f91001260115q3fe86964l7ea1c8f9c69cb5e9@mail.gmail.com>
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation 
	environments
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Hui Zhu <hui.zhu@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 5:13 PM, Hui Zhu <hui.zhu@windriver.com> wrote:
>
> What do you think about it?
>
> And I changed the other part according to your mail.


It looks fine for me now, I assume you already tested it.


>
> Best regards,
> Hui
>
> The markup_oops.pl have 3 troubles to support cross-compiler environment:
> 1.  It use objdump directly.
> 2.  It use modinfo to get the message of module.
> 3.  It use hex function that cannot support 64-bit number in 32-bit arch.
>
> This patch add 3 options to markup_oops.pl:
> 1. -c CROSS_COMPILE     Specify the prefix used for toolchain.
> 2. -m MODULE_DIRNAME    Specify the module directory name.
> 3. Change hex function to Math::BigInt->from_hex.
>
> After this patch, parse the x8664 oops in x86, we can:
> cat amd64m | perl ~/kernel/tmp/m.pl -c /home/teawater/kernel/bin/x8664- -m
> ./e.ko vmlinux
>
> Thanks,
> Hui
>
> Signed-off-by: Hui Zhu <teawater@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: ozan@pardus.org.tr
> Cc: Matthew Wilcox <willy@linux.intel.com>
>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
