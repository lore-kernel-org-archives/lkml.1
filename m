Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYFYR2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYFYR2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYFYR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:28:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:13667 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYFYR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GtDXTzAzl6NrNycNls9/PonsGaMC5KDX4OLb854IBkS30Z6p7wCYp8Zd6nvpdXRfE5
         wgytCiJmaIrqzEJeDJYEVLBP/OvWpPMgXuG/tUQr8CkISbIrqh19MwlJp9CYT5lWMVC+
         EvCc/TXwAWfUumDsBpm23PGC79dFGsc1yyEUw=
Message-ID: <86802c440806251028sb9a98e3ncbae3b3130c02fa6@mail.gmail.com>
Date: Wed, 25 Jun 2008 10:28:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH] x86: Merge setup_32/64.c into setup.c
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080625164300.GC6040@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806242213.15310.yhlu.kernel@gmail.com>
	 <200806242214.09503.yhlu.kernel@gmail.com>
	 <200806250114.09858.yhlu.kernel@gmail.com>
	 <20080625153614.GB18796@elte.hu>
	 <86802c440806250844s51b50311va1c8e9c9fc1da510@mail.gmail.com>
	 <20080625164300.GC6040@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 9:43 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> >>  include/asm-x86/setup.h    |    2
>> >>  5 files changed, 670 insertions(+), 934 deletions(-)
>> >
>> > very nice!
>> >
>> > could we please split this up into several, gradual steps that bring
>> > setup_32.c and setup_64.c to exactly the same content - where the final
>> > patch just renames arch/x86/kernel/setup_32.c to arch/x86/kernel/setup.c
>> > and deletes arch/x86/kernel/setup_64.c ?
>>
>> OK, someone (Mike Triavis) already stole setup.c for X86_NUMA.
>>
>> You need to change that setup.c to other name. or split it away...
>
> hm, that change was supposed to be the seed of a unification. So if it
> actually hinders you, feel free to move it to a different file.
> Obviously it is setup_32.c and setup_64.c that should be unified into
> setup.c.

ok, I will change that setup_percpu.c

YH
