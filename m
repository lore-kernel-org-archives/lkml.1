Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbYKLLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbYKLLSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYKLLS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:18:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:49727 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYKLLS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:18:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PzMhWVIdUhsWYUPU8MXot+2r3j+5q9z6yIfoT2pEnt091aOtgCOTdsxp8tWQLF/ty1
         9y5myoSnwDzk5x4K3bwWVE0JTMzMFw2pag4aH6QRJYyUaY87gvfvclcYyVH7iYkOh/7k
         /vJiozea3KagT7JTZikpFtytrxUVjxCeHj/Is=
Message-ID: <8bd0f97a0811120318m52ccbde4g5434ddfb3f56e048@mail.gmail.com>
Date: Wed, 12 Nov 2008 06:18:26 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>
In-Reply-To: <Pine.LNX.4.64.0811120859160.13217@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
	 <20081106183939.GA26925@x200.localdomain>
	 <Pine.LNX.4.64.0811061310350.6009@quilx.com>
	 <20081107162114.2a41c623.sfr@canb.auug.org.au>
	 <Pine.LNX.4.64.0811120859160.13217@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 02:59, Geert Uytterhoeven wrote:
> On Fri, 7 Nov 2008, Stephen Rothwell wrote:
>> On Thu, 6 Nov 2008 13:15:07 -0600 (CST) Christoph Lameter wrote:
>> > On Thu, 6 Nov 2008, Alexey Dobriyan wrote:
>> > > On blackfin-BF526-EZBRD and other blackfins:
>> > >
>> > >   LD      .tmp_vmlinux1
>> > > mm/built-in.o: In function `cpu_alloc_init':
>> > > (.init.text+0x1486): undefined reference to `__per_cpu_start'
>> > > mm/built-in.o: In function `cpu_alloc_init':
>> > > (.init.text+0x148c): undefined reference to `__per_cpu_start'
>> > > mm/built-in.o: In function `cpu_alloc_init':
>> > > (.init.text+0x1492): undefined reference to `__per_cpu_end'
>> > > mm/built-in.o: In function `cpu_alloc_init':
>> > > (.init.text+0x1496): undefined reference to `__per_cpu_end'
>> >
>> > Any contigencies for __per_cpu_start/end in your blackfin vmlinux.lds.h?
>> > That is where these symbols are defined
>> >
>> > Or did you use generic percpu support and set
>> > CONFIG_HAVE_ZERO_BASED_PER_CPU?
>>
>> Also a avr32 allnoconfig
>> (http://kisskb.ellerman.id.au/kisskb/buildresult/53233/) gets:
>>
>> backing-dev.c:(.init.text+0xc4c): undefined reference to `__per_cpu_start'
>> backing-dev.c:(.init.text+0xc50): undefined reference to `__per_cpu_end'
>>
>> and avr32 defconfig
>> (http://kisskb.ellerman.id.au/kisskb/buildresult/53225/) gets:
>>
>> vmstat.c:(.init.text+0xff0): undefined reference to `__per_cpu_start'
>> vmstat.c:(.init.text+0xff4): undefined reference to `__per_cpu_end'
>
> And m68k defconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/54216/):
>
> | : undefined reference to `__per_cpu_start'
> | : undefined reference to `__per_cpu_end'

i already posted a patch:
http://lkml.org/lkml/2008/11/8/145
-mike
