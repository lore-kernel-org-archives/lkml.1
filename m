Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYIKHFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYIKHFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYIKHFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:05:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:33235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYIKHFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,377,1217833200"; 
   d="scan'208";a="379072759"
From: "Yang, Sheng" <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] Clean up for MSR_IA32_FEATURE_CONTROL
Date: Thu, 11 Sep 2008 15:05:07 +0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
References: <1221100432-9511-1-git-send-email-sheng.yang@intel.com> <20080911063523.GA27877@elte.hu>
In-Reply-To: <20080911063523.GA27877@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809111505.07875.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 14:35:23 Ingo Molnar wrote:
> * Sheng Yang <sheng.yang@intel.com> wrote:
> > Hi, Ingo
> >
> > Here is some follow up clean up for "Move VMX MSRs to msr-index.h".
> > After discussion with Avi, I found it's more proper to move
> > MSR_IA32_FEATURE_CONTROL bits to msr-index.h as well.
> >
> > But I got a little puzzle about where to accept these patches. I
> > suppose these can be picked up by tip then go with kvm when it merge
> > upstream? The main problem is macro name changed to keep consistent
> > style.
>
> there's a few changes pending for that file:
>
>   earth4:~/tip> gll linus.. include/asm-x86/msr-index.h
>   315a655: x86: move VMX MSRs to msr-index.h
>   77ef50a: x86: consolidate header guards
>
> so i guess best is to put 315a655 into kvm.git as well and do these
> changes there. The header-guard changes should not cause significant
> merge trouble.
>

OK, I will resend the patches to KVM mailing list(o, forgot to CC them 
here...)

Thanks!

-- 
regards
Yang, Sheng


> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


