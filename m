Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448Ab0ALIuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0ALIuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797Ab0ALIuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:50:55 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:62679 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0ALIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:50:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WPtIVVC6ItGrIXFM/YKKJv+oTIyNHhIYv53Mnqppy+/kQ4bQKMlW+gmM09c6MR1FX3
         bm6Ex0t9fD02AtakxCXfAQdwEELOZHhwtoz9LpQHS/5VvYEEsl6TUTsuu9ck/JVpPTDk
         o2sPfCFewaT3hodi3FbbCPllOwlxkU9WOb7IM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001111917190.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-3-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111917190.17145@localhost.localdomain>
Date: Tue, 12 Jan 2010 00:50:52 -0800
X-Google-Sender-Auth: 6564829ad1967b3a
Message-ID: <86802c441001120050s65bb20f7w1fb865a40cf4732e@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] x86: according to nr_cpu_ids to decide if need to 
	leave logical flat
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 7:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 11 Jan 2010, Yinghai Lu wrote:
>> +
>> +void default_setup_apic_routing(void)
>
> Good cleanup, makes x86-64 and x86-32 look similar. However, you should
> mark it __init too, I think, to match the current probe_64.c thing.
>
> Also, what about the default_setup_apic_routing() call in
> arch/x86/kernel/apic/apic.c? Is that not ripe for unification too now? You
> only did the smpboot.c one, not the APIC_init_uniprocessor() one.
>
that was intentionally. because one cpu, don't need to switch to bigsmp..

will make the change to that to make them consistent.

YH
