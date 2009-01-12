Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZALLJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZALLJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZALLI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:08:56 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:6494 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZALLIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:08:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NGcpFeh7w6xJL6rs5nC0AEVNhLNcwJptG1y9mv/aMB7zOlacphWmwg5bdavlB01lWp
         /RS5y21vQ+tsEqWaJkIgVZhV3lmm7CYHv4taATdO/2DYAQsgHm6Ywe2WECwyLJrCwDue
         q99lGNpOxfgTJoK7rzph/PudG0SFUUKUhaq2o=
Message-ID: <3f9a31f40901120308h32665bx9365c9b745138449@mail.gmail.com>
Date: Mon, 12 Jan 2009 16:38:54 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       linux-kernel@vger.kernel.org,
       "Jaswinder Singh Rajput" <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <3f9a31f40901120257m27a9b047kd8dcee2793467bb3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
	 <20090112105202.GF10405@elte.hu>
	 <3f9a31f40901120257m27a9b047kd8dcee2793467bb3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 4:27 PM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> On Mon, Jan 12, 2009 at 4:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Jiri Kosina <jkosina@suse.cz> wrote:
>>
>>> Hi,
>>>
>>> with Linus' tree (ae04d14015) doesn't build for me with
>>>
>>> arch/x86/kernel/ldt.c: In function 'alloc_ldt':
>>> arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
>>> arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
>>>
>>> Config on http://www.jikos.cz/jikos/junk/.config
>>
>> hm, it builds fine here with your config. Did .28 build fine for you? The
>> only change to this file since .28 has been Jaswinder's "423a540: x86:
>> ldt.c fix style problems".
>>
>
> No, it is not because of my patch but I will check for the solution.
>
>

With your config I am also not getting any error with -tip tree:

  CC      arch/x86/kernel/dumpstack_64.o
  CC      arch/x86/kernel/time_64.o
  CC      arch/x86/kernel/ioport.o
  CC      arch/x86/kernel/ldt.o
  CC      arch/x86/kernel/dumpstack.o

Jiri, make clean and also check for -tip tree.

Thanks,
--
JSR
