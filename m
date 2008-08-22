Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYHVFG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYHVFG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 01:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYHVFGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 01:06:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:62883 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYHVFGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 01:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QedXmsmcbEZYkUusNxd2R1cOGCQcdXU66EuR0gg2u1wal93M0VnKCA+U3CXfeGNiv9
         j1bfbWIFyLHK/ivFmVyk8iazw+h1Ng+4OsOyoJMaRaJZWz1mm6aqkS13Bsftv1O+aOtZ
         78qAQFt7GhYVqff0mhhETK4jKSzKBUME/v89Y=
Message-ID: <86802c440808212206s66c31203n651ca021c01104ca@mail.gmail.com>
Date: Thu, 21 Aug 2008 22:06:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alex Nixon" <alex.nixon@citrix.com>,
       "Alan Mayer" <ajm@sgi.com>
In-Reply-To: <20080822042610.GA15212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>
	 <48ADFB33.8010204@goop.org>
	 <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com>
	 <48ADFFD2.7030309@goop.org>
	 <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com>
	 <48AE022F.6030100@goop.org> <20080822042610.GA15212@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 9:26 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> > hope we can kill nr_irqs/NR_IRQS
>>
>> When irqs are truely dynamically allocated?
>
> they in essence already are truly dynamic in tip/master. Not yet
> unconditionally so on x86, we chose to also have a !SPARSEIRQ build
> model to make sure dense IRQ arrays still work fine as well. (that's far
> easier to test and validate than to keep a farm of cross compilers to
> other arches alive.)
>
> But by all means SPARSEIRQ is the primary and only model on x86.
>
> We could even plug in the dynamic vector allocator from Alan Mayer now,
> both on 32-bit and on 64-bit x86: Yinghai, any complications expected
> there? I guess we need to unify the local APIC code first.

apic_32.c and apic_64.c
irqinit_32.c and irqinit_64.c
irq_32.c and irq_64.c

Cyrill, is still working on merging apic_32.c apic_64.c.?

YH
