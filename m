Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZEZK2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZEZK2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbZEZK2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:28:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35908 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZEZK2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KqyjjosgYChs5P6MCWlFq57gG027RtkMeQGPiG6uwientYZq3U04gQyJchEgpJRpCA
         AoNQYWdRS6rh3U7EvAyJDTRZs4gLu+c4Rn1FVGDmvXRSvue+P10227zffWK7NI+vBdK5
         KPhF+VwavIhDnPNI0e/TKEht1QX6q+isV3vjk=
MIME-Version: 1.0
In-Reply-To: <20090526102502.GA24737@infradead.org>
References: <1243332633-15258-1-git-send-email-vapier@gentoo.org>
	 <20090526102502.GA24737@infradead.org>
Date: Tue, 26 May 2009 06:28:14 -0400
Message-ID: <8bd0f97a0905260328ndaa5b64x212eda09d2e20d15@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH] drivers/char/rtc: disable legacy RTC 
	driver on Blackfin systems
From: Mike Frysinger <vapier.adi@gmail.com>
To: rtc-linux@googlegroups.com
Cc: Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 06:25, Christoph Hellwig wrote:
> On Tue, May 26, 2009 at 06:10:33AM -0400, Mike Frysinger wrote:
>>       tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
>>       depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
>> -                     && !ARM && !SUPERH && !S390 && !AVR32
>> +                     && !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN
>
> Maybe it's better to have a positive dependency for those that actually
> support it these days?  Based on the above list that would be:
>
>        depends on ALPHA || CRIS || H8300 || M32R || MICROBLAZE ||
>                   MIPS || MN10300 || SH || X86 || XTENSA
>
> and I would not be surprised if some of the above don't actually support
> it either..

it was my understanding that this driver was destined to be dropped
down the line ... easier to extend the cruft for now than try to ping
arch maintainers for confirmation ...
-mike
