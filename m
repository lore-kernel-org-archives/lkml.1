Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbXLFCX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbXLFCX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbXLFCXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:23:08 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44834 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbXLFCXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:23:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Natalie Protasevich" <protasnb@gmail.com>
Cc: "Len Brown" <lenb@kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
References: <200711280121.18376.lenb@kernel.org>
	<32209efe0712050525j486922a9s471f3871e69aedff@mail.gmail.com>
	<m1mysovi5k.fsf@ebiederm.dsl.xmission.com>
	<32209efe0712051548n72f60b0eofa130f28701ca77@mail.gmail.com>
Date: Wed, 05 Dec 2007 19:20:52 -0700
In-Reply-To: <32209efe0712051548n72f60b0eofa130f28701ca77@mail.gmail.com>
	(Natalie Protasevich's message of "Wed, 5 Dec 2007 15:48:28 -0800")
Message-ID: <m1eje0va0r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Natalie Protasevich" <protasnb@gmail.com> writes:

> I think we counted them in the order of 1400 external IRQs (actual
> ioapics/slots plus possible on-card bridges), and yes numbers for used
> IRQs were close to 250. Actual customer configurations could've big
> bigger, I don't have such data.
>
>> In particular is a large NR_IRQS plus dynamic vector allocation
>> sufficient for all cases you know about?
>
> Yes, since x86_64 boxes never had a problem once dynamic vectors were
> incorporated.

I was wondering if we could avoid making the vectors per cpu and still be
in good shape on x86_32.  From your description it looks like we can't
quite support everything on x86_32 if we don't do the per cpu vector
thing.  However we will likely have everything interesting supported.

Eric
