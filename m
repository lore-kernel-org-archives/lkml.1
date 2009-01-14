Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbZANJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbZANJa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbZANJ36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:29:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:14415 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546AbZANJ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KOFt7K0Xkbo1rGQXR/CVIGhyAlMd7gRxUlMJTrz6RCg3OIiTWOgJawpD1gQPyo9tVI
         du7rrk8gmQaxMV6oWPsYFCDUilLO77KQkFqK3XViRIFzq2hBRE9dp6O0zSCmI4doYzLh
         jpo3YEGKnlGXWFQZEpQsPkWTKiI0aKnXnxDJM=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0901140954250.27308@anakin>
References: <1231836016.3212.41.camel@jaswinder.satnam>
	 <Pine.LNX.4.64.0901140954250.27308@anakin>
Date: Wed, 14 Jan 2009 14:59:54 +0530
Message-ID: <3f9a31f40901140129i1389f47frf32808f3a695a118@mail.gmail.com>
Subject: Re: [PULL -tip] fixed few make headers_check warnings
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Geert,

On Wed, Jan 14, 2009 at 2:26 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, 13 Jan 2009, Jaswinder Singh Rajput wrote:
>> Please pull these patches. Earlier I also floated these patches so that I can get some feedback.
>>
>> The following changes since commit ae2659bcd0b5bf34dd4b03f1db0a2942cc09b8e6:
>>   Ingo Molnar (1):
>>         Merge branch 'x86/mm'
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
>>
>> Jaswinder Singh Rajput (7):
>>       include of <linux/types.h> is preferred over <asm/types.h>
>>       found __[us]{8,16,32,64} type without #include <linux/types.h>
>>       capability.h: extern's make no sense in userspace
>>       coda_psdev.h: extern's make no sense in userspace
>>       in6.h: extern's make no sense in userspace
>>       nubus.h: extern's make no sense in userspace
>>       socket.h: extern's make no sense in userspace
>
> May I please remind you of my comment in
> http://patchwork.kernel.org/patch/2093/?
>

Thanks for your reminder :-)

> At least nubus.h still leaks forward declarations for kernel functions that
> lack the "extern" keyword, so they still pollute user space.
>

Yes, you are right, I just tried to pampered weeping warning messages
which is annoying.

In this subset, I just try to fix 77 such warnings.

nubus.h still have such warnings and other fixes required which you
are pointing so I am expecting nubus people will solve such problems.

Thanks
--
JSR
