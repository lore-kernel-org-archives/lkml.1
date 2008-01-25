Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbYAYJad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbYAYJad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbYAYJaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:30:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:40677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbYAYJaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:30:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,249,1199692800"; 
   d="scan'208";a="329797882"
Subject: Re: [PATCH 4/6] x86: fix some bugs about EFI runtime code mapping
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080125091923.GE23708@elte.hu>
References: <1201240501.15972.46.camel@caritas-dev.intel.com>
	 <4799914C.5060709@goop.org>  <20080125091923.GE23708@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 17:30:37 +0800
Message-Id: <1201253437.15972.60.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 09:29:54.0785 (UTC) FILETIME=[D80EDD10:01C85F34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-25 at 10:19 +0100, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> >>  +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> >> +static void __init runtime_code_page_mkexec(void)
> >> +{
> >> +	efi_memory_desc_t *md;
> >> +	unsigned long end;
> >> +	void *p;
> >> +
> >> +	if (!(__supported_pte_mask & _PAGE_NX))
> >> +		return;
> >>   
> >
> > On 32-bit non-PAE, _PAGE_NX == 0, so this if() statement should be 
> > sufficient to disable the whole function at compile time without 
> > needing the outer #if defined wrapper.
> 
> good point. The patch fixes bugs and the consolidation it does is very 
> nice so i've applied it already, but we could indeed further consolidate 
> it and make it a nice #ifdef-less function. Could one of you send an 
> add-on patch for this?

I will do it. But I have some other thing to do now, so I will send it
on next Monday.

Best Regards,
Huang Ying

