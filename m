Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYHSSZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYHSSZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYHSSYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:24:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:62708 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYHSSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mCqtGo/Rss5B6R1HQyKUS4Nw07X/lGS6L7tvPgwCbHmHRLtKWuVetPP2q4MsF54l36
         3CgwIw/CbvD5fnDMj6cFVbFTwpG/wUE2VdCipWvVyv0pQe0pFK457Kj+pllsKEEVZGUl
         qiap4uyummHdyAM4P919HJ8faD27im+CRSOcE=
Message-ID: <86802c440808191124v39ce2aa9rb548d3bdd75ca25c@mail.gmail.com>
Date: Tue, 19 Aug 2008 11:24:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alex Nixon (Intern)" <Alex.Nixon@citrix.com>
Subject: Re: [PATCH] X86: Change the default value of nr_irqs from 32 to NR_IRQs
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AAFAE4.7070409@citrix.com>
	 <86802c440808191044h74871ba1u62330dae18599436@mail.gmail.com>
	 <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:13 AM, Alex Nixon (Intern)
<Alex.Nixon@citrix.com> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>On Tue, Aug 19, 2008 at 9:55 AM, Alex Nixon <alex.nixon@citrix.com> wrote:
>>>
>>> If the number of discovered IRQs is suspiciously low, this patch causes
>>> the number reported to default to NR_IRQS, rather than 32.  NR_IRQS has
>>> already been defined to be a >sensible value for the current system (in
>>> particular, at least 224 when paravirtualisation is involved).
>>>
>>if only one ioapic, nr will be 24<<1, you will get 48. Does pv has io apic
>> ?
>>
>>YH
>>
> I'm not sure about the general case, but Xen does not (Jeremy correct me if
> I'm wrong).
>
> Unless I'm missing something (which I may well be; I'm new to this area of
> code), it seems more logical anyway to default back to the calculated
> system-specific value (NR_IRQS), instead of 32, which seems rather
> arbitrary.

can you try !CONFIG_HAVE_SPARSE_IRQ and CONFIG_HAVE_SPARSE_IRQ ?

YH
