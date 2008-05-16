Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYEPMiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYEPMiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYEPMim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:38:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYEPMim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:38:42 -0400
Date: Fri, 16 May 2008 14:38:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
	memory entries to kernel
Message-ID: <20080516123820.GA16520@elte.hu>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com> <20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com> <20080515190340.b232ca7d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515190340.b232ca7d.pj@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> I invite your review of these patches, especially 7, 9 and 10 of the 
> set of 10, that I posted yesterday.

thanks Paul, i've queued up your changes to the -tip tree - they look 
nice and finegrained.

I merged them ontop of Yinghai's e820 unification work. The merge was 
far from trivial (functions you were patching moved to other files, 
interface definitions changed, etc.) so double-checking it would be 
nice. This will all show up in the x86/mtrr branch in -tip, probably 
later today.

	Ingo
