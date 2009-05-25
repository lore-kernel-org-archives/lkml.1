Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZEYFtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZEYFtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEYFtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:49:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:3542 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZEYFtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:49:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,243,1241420400"; 
   d="scan'208";a="518584048"
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
From: Huang Ying <ying.huang@intel.com>
To: "Anvin, H Peter" <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Maly <bmaly@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dannf@hp.com" <dannf@hp.com>
In-Reply-To: <49ECBD31.9010607@intel.com>
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com>
	 <49DA8875.5050009@redhat.com>
	 <20090409161803.f79c0b64.akpm@linux-foundation.org>
	 <20090410135102.GB24809@elte.hu> <49ECADAB.4020609@redhat.com>
	 <20090420172045.GA17887@elte.hu>  <49ECBD31.9010607@intel.com>
Content-Type: text/plain
Date: Mon, 25 May 2009 13:49:07 +0800
Message-Id: <1243230547.31256.65.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 02:21 +0800, Anvin, H Peter wrote:
> Ingo Molnar wrote:
> > * Brian Maly <bmaly@redhat.com> wrote:
> > 
> >>> Hm, it would be nice to first unify the relevant bits of 
> >>> arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and 
> >>> then we can apply such patches without duplicative effects.
> >> Ingo,
> >>
> >> Are you OK with consolidating this into arch/x86/kernel/rtc.c as 
> >> Huang Ying had suggested? This seems like the most logical place 
> >> for the rtc-efi init to happen, but your suggestion to consolidate 
> >> this into arch/x86/kernel.time.c may have advantages that I am not 
> >> aware of.  Anyway, I would appreciate any insight/opinions on this 
> >> if you have any.  Thanks.
> > 
> > Yes, that indeed sounds like an even better place for it.
> > 
> 
> Furthermore, the EFI RTC code probably should be in its own file.
> 
> In fact, arch/x86/kernel really could use more subdirectories; at least 
> the EFI and UV-specific code should be be moved out.

Or, do you think it is appropriate to re-organize EFI related code into
a sub-architecture?

Best Regards,
Huang Ying


