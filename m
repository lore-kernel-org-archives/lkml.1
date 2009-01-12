Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZALLUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZALLUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZALLTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:19:52 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:1266 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZALLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A9QU2yR7MQS5FheoVUS29AFbz877nA8keZH34anTrTt2QwkecfQ91bNqqyU7ws5cEh
         Jeq2uV6vjxLYceOD3L/00C3wZZJ7rYlCkGJZycV4dgMH17Kqiqn6QGKqfqWDjTXv9Ggr
         vwWXHg1O6WNpGThIkYxm9210SNt+p1YvZ4pT8=
Message-ID: <3f9a31f40901120319l4fac84e4me193fb314bdbbcaa@mail.gmail.com>
Date: Mon, 12 Jan 2009 16:49:50 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       linux-kernel@vger.kernel.org,
       "Jaswinder Singh Rajput" <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
	 <20090112105202.GF10405@elte.hu>
	 <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 4:42 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 12 Jan 2009, Ingo Molnar wrote:
>
>> > with Linus' tree (ae04d14015) doesn't build for me with
>> >
>> > arch/x86/kernel/ldt.c: In function 'alloc_ldt':
>> > arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
>> > arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
>> >
>> > Config on http://www.jikos.cz/jikos/junk/.config
>>
>> hm, it builds fine here with your config. Did .28 build fine for you? The
>> only change to this file since .28 has been Jaswinder's "423a540: x86:
>> ldt.c fix style problems".
>
> Puzzled. On one system, I still get this build error even after make
> mrpoper (I use this machine to build kernel routinely, so it certainly
> didn't happen a few days ago).
>
> But I just tried on different system, and there is builds flawlessly. It's
> gcc 4.3.1 vs 4.3.2. I will check a little bit more.
>

I am using gcc 4.3.2

Please check 'git diff' if by mistake some thing is gone wrong or
check 'git log'

--
JSR
