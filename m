Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZALLg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZALLg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZALLgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:36:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:2939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZALLgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:36:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CE6ukPSV9vRLMGD8pky4YzSEAIHJBOT81TPt9jZx9G+G331usyB4m/HgR1ca89ERHQ
         7LVnZgtZG7eFFi7V5oubv6eQA2XdcxqUNoa5xN/CxOPiZqixEm2XKead6Ot3soVO05RR
         hbudxImFC+OmayPDfOGTc3Gnb07h17co72suE=
Message-ID: <3f9a31f40901120336p5ef464e8ta4a9eac2b397b5f6@mail.gmail.com>
Date: Mon, 12 Jan 2009 17:06:14 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       linux-kernel@vger.kernel.org,
       "Jaswinder Singh Rajput" <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20090112112458.GA19388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
	 <20090112105202.GF10405@elte.hu>
	 <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz>
	 <3f9a31f40901120319l4fac84e4me193fb314bdbbcaa@mail.gmail.com>
	 <20090112112458.GA19388@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 4:54 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>
>> On Mon, Jan 12, 2009 at 4:42 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> > On Mon, 12 Jan 2009, Ingo Molnar wrote:
>> >
>> >> > with Linus' tree (ae04d14015) doesn't build for me with
>> >> >
>> >> > arch/x86/kernel/ldt.c: In function 'alloc_ldt':
>> >> > arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
>> >> > arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
>> >> >
>> >> > Config on http://www.jikos.cz/jikos/junk/.config
>> >>
>> >> hm, it builds fine here with your config. Did .28 build fine for you? The
>> >> only change to this file since .28 has been Jaswinder's "423a540: x86:
>> >> ldt.c fix style problems".
>> >
>> > Puzzled. On one system, I still get this build error even after make
>> > mrpoper (I use this machine to build kernel routinely, so it certainly
>> > didn't happen a few days ago).
>> >
>> > But I just tried on different system, and there is builds flawlessly. It's
>> > gcc 4.3.1 vs 4.3.2. I will check a little bit more.
>> >
>>
>> I am using gcc 4.3.2
>>
>> Please check 'git diff' if by mistake some thing is gone wrong or check
>> 'git log'
>
> That wont show working tree corruption.
>

It works for me for my old 166 MHz pentium machine after crashing the
system, 'git diff' tells which files are broken ;-)
