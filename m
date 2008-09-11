Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYIKBxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYIKBxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 21:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYIKBxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 21:53:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:62530 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYIKBxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 21:53:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,375,1217833200"; 
   d="scan'208";a="615005563"
From: "Yang, Sheng" <sheng.yang@intel.com>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 1/2] x86: Move VMX MSRs to msr-index.h
Date: Thu, 11 Sep 2008 09:56:32 +0800
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <12208705553277-git-send-email-sheng.yang@intel.com> <200809101844.16091.sheng.yang@intel.com> <48C7D9F7.4020506@qumranet.com>
In-Reply-To: <48C7D9F7.4020506@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809110956.32777.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 22:30:15 Avi Kivity wrote:
> Yang, Sheng wrote:
> > On Tuesday 09 September 2008 21:47:03 Avi Kivity wrote:
> >> Sheng Yang wrote:
> >>> They are hardware specific MSRs, and we would use them in
> >>> virtualization feature detection later.
> >>>
> >>>
> >>>
> >>>
> >>> -
> >>> -#define MSR_IA32_FEATURE_CONTROL                0x3a
> >>>  #define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
> >>>  #define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x
> >>
> >> Might as well move these two bitmask definitions.
> >
> > Um... I think it's better to leave them here, for the
> > MSR_IA32_FEATURE_CONTROL is a MSR which can be put into msr-index.h, but
> > the others are only bits of MSR...
>
> The EFER bits are in msr-index.h, and I think the msr index in one file
> and the bits in another detract from clarity.

I agree now, sorry for miss that... 

Would post another patch(es) to do this clean up...

-- 
regards
Yang, Sheng
