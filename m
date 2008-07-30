Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbYG3KQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbYG3KQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYG3KQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:16:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:28596 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYG3KQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xt95+nj6a7yztscAp1vq/YMDERmYs1B7M0Ll8LFavqjKyYT4v2jf3DK3Su0Dv8knP3
         6aZ6ek0Wfg7ffpX1zMOHXd4ZQbwbGNIav7CIf0xhcTTPLC32uxlNZ3PGHhBOhd7O6YAn
         N3CiRCNcSscq1pXf7Zd2FvHGkUrZgixyUvk8E=
Message-ID: <86802c440807300316r5020b358r3334ccb38370c9e3@mail.gmail.com>
Date: Wed, 30 Jul 2008 03:16:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: RFC [PATCH] x86: introduce nr_irqs for 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080730100926.GA10431@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807291414.55479.yhlu.kernel@gmail.com>
	 <200807292138.41720.yhlu.kernel@gmail.com>
	 <20080730100926.GA10431@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 3:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> add DEFINE_DYN_ARRAY for dynamical array support
>>
>> todo:
>> 1. convert x86 32bit and other arch
>> 2. nr_irqs auto probe via acpi_oem_check?
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> wonderful!
>
> I have one main structural suggestion: could we please keep the NR_IRQS
> name, and just change it to dynamic on x86? NR_IRQS is used in 540
> places in the kernel, there's no point in touching all that code.
>
> Also add an CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS switch, define it in
> arch/x86/Kconfig and use it in include/linux/irq.h.
>
> This will create far less migration pain than the widespread rename.
> That will also solve the "what about the other architectures" question.

just send out v2.

long term, i hope to make all arch to use nr_irqs and probe it
earlier. and kill NR_IRQS

YH
