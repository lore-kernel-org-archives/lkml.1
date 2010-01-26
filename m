Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898Ab0AZJVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0AZJVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584Ab0AZJVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:21:30 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34790 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0AZJV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:21:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qrUwWh2BryP+uOjOty4VMuGH3MHKP2dmOhdLBmolob8psoEcrwnMIqG/yyOR54f0i7
         y0A8RtgR9pYDKCiaJc85b0VR5MCX43SmwS1jzQViDLqqyTp6RaWHtwch9Be5nAHmHKUd
         p87Vw16Yvvjmt0p5Og6CXQDC5KRuvx2HWfGLw=
MIME-Version: 1.0
In-Reply-To: <2375c9f91001260115q3fe86964l7ea1c8f9c69cb5e9@mail.gmail.com>
References: <4B5E5D4F.50803@windriver.com> <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com> 
	<4B5E9BE9.2030702@windriver.com> <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com> 
	<4B5EB223.60307@windriver.com> <2375c9f91001260115q3fe86964l7ea1c8f9c69cb5e9@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 26 Jan 2010 17:21:08 +0800
Message-ID: <daef60381001260121q675ecb30r2099c085c40d7964@mail.gmail.com>
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation 
	environments
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Hui Zhu <hui.zhu@windriver.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Américo,

On Tue, Jan 26, 2010 at 17:15, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Jan 26, 2010 at 5:13 PM, Hui Zhu <hui.zhu@windriver.com> wrote:
>>
>> What do you think about it?
>>
>> And I changed the other part according to your mail.
>
>
> It looks fine for me now, I assume you already tested it.

It was tested.  :)

>
>
>>
>> Best regards,
>> Hui
>>
>> The markup_oops.pl have 3 troubles to support cross-compiler environment:
>> 1.  It use objdump directly.
>> 2.  It use modinfo to get the message of module.
>> 3.  It use hex function that cannot support 64-bit number in 32-bit arch.
>>
>> This patch add 3 options to markup_oops.pl:
>> 1. -c CROSS_COMPILE     Specify the prefix used for toolchain.
>> 2. -m MODULE_DIRNAME    Specify the module directory name.
>> 3. Change hex function to Math::BigInt->from_hex.
>>
>> After this patch, parse the x8664 oops in x86, we can:
>> cat amd64m | perl ~/kernel/tmp/m.pl -c /home/teawater/kernel/bin/x8664- -m
>> ./e.ko vmlinux
>>
>> Thanks,
>> Hui
>>
>> Signed-off-by: Hui Zhu <teawater@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: ozan@pardus.org.tr
>> Cc: Matthew Wilcox <willy@linux.intel.com>
>>
>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>

Thanks,
Hui
