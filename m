Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYKUAul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYKUAul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 19:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYKUAub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 19:50:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYKUAua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 19:50:30 -0500
Date: Fri, 21 Nov 2008 01:50:26 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Hugh Dickins <hugh@veritas.com>,
       Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Message-ID: <20081121005026.GB27293@wotan.suse.de>
References: <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com> <20081113034425.GA23434@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC4642775AF2@orsmsx505.amr.corp.intel.com> <20081114020547.GA24414@wotan.suse.de> <7E82351C108FA840AB1866AC776AEC46427EC16C@orsmsx505.amr.corp.intel.com> <20081117023019.GB1943@wotan.suse.de> <20081118213735.GB28825@elte.hu> <7E82351C108FA840AB1866AC776AEC4642A9C879@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4642A9C879@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 03:42:32PM -0800, Pallipadi, Venkatesh wrote:
>  
> 
> >-----Original Message-----
> >From: linux-kernel-owner@vger.kernel.org 
> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ingo Molnar
> >Sent: Tuesday, November 18, 2008 1:38 PM
> >To: Nick Piggin
> >Cc: Pallipadi, Venkatesh; Thomas Gleixner; H Peter Anvin; Hugh 
> >Dickins; Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; 
> >Arjan van de Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
> >Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
> >
> >
> >patchset need acks from MM folks - Andrew, Nick or Hugh - we cannot 
> >just queue them up in the x86/pat tree without agreement from MM 
> >maintainers.
> >
> 
> OK. Feedback based on the discussions on this patchset, this particular patch
> set VM_PFNMAP flag in vm_insert_pfn
> is not really needed and we should rather BUG_ON on that not being set. 
> And there were few more comments on one other generic vm patch from Nick.
> 
> I will resend the entire patchset with changes soon and then we can work
> out the logistics.

So long as it has been reviewed by mm people (cc'ing linux-mm might be
nice), I don't care so much how it makes its way upstream. If it was
a lot of code, it might make sense to slowly work dependencies though
various subsystems... but this isn't too much on the mm side, and it is
primarily support code for x86 subsystem feature so I don't mind myself
if it went via the x86 tree, with appropriate acks.

