Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZDTSWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZDTSWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZDTSVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:21:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:61242 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbZDTSVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,218,1239001200"; 
   d="scan'208";a="449596617"
Message-ID: <49ECBD31.9010607@intel.com>
Date: Mon, 20 Apr 2009 11:21:37 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Maly <bmaly@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dannf@hp.com" <dannf@hp.com>, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com> <49DA8875.5050009@redhat.com> <20090409161803.f79c0b64.akpm@linux-foundation.org> <20090410135102.GB24809@elte.hu> <49ECADAB.4020609@redhat.com> <20090420172045.GA17887@elte.hu>
In-Reply-To: <20090420172045.GA17887@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Brian Maly <bmaly@redhat.com> wrote:
> 
>>> Hm, it would be nice to first unify the relevant bits of 
>>> arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and 
>>> then we can apply such patches without duplicative effects.
>> Ingo,
>>
>> Are you OK with consolidating this into arch/x86/kernel/rtc.c as 
>> Huang Ying had suggested? This seems like the most logical place 
>> for the rtc-efi init to happen, but your suggestion to consolidate 
>> this into arch/x86/kernel.time.c may have advantages that I am not 
>> aware of.  Anyway, I would appreciate any insight/opinions on this 
>> if you have any.  Thanks.
> 
> Yes, that indeed sounds like an even better place for it.
> 

Furthermore, the EFI RTC code probably should be in its own file.

In fact, arch/x86/kernel really could use more subdirectories; at least 
the EFI and UV-specific code should be be moved out.

	-hpa

