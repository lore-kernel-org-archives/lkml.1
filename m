Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbXFLRAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbXFLRAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbXFLRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:00:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56198 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbXFLRAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:00:04 -0400
Date: Tue, 12 Jun 2007 09:58:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, Stable Team <stable@kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [stable] [PATCH] ACPI: Move timer broadcast and pmtimer
	accessbefore C3 arbiter shutdown
Message-ID: <20070612165851.GM3723@sequoia.sous-sol.org>
References: <1181636767.8176.199.camel@chaos> <653FFBB4508B9042B5D43DC9E18836F50101D9F3@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F50101D9F3@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pallipadi, Venkatesh (venkatesh.pallipadi@intel.com) wrote:
> > * Thomas Gleixner (mailto:tglx@linutronix.de) wrote: 
> > I fixed this against -mm already. I don't think that it is relevant for
> > stable. The issue was found with Venkis hpet force enable patches on a
> > ICH4 system. I doubt that any of those systems has hpet enabled in the
> > BIOS. It should not affect later ICH chip sets. Venki, is this 
> > correct ?
> 
> Yes. This issue is only when HPET timer is used on ICH4. And by default 
> HPET is not enabled on those chipsets. So, we don't need this patch
> for stable.

Great, thanks.
-chris
