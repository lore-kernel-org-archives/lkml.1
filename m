Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYANQsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYANQsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYANQsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:48:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbYANQsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:48:32 -0500
Date: Mon, 14 Jan 2008 17:47:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: venkatesh.pallipadi@intel.com, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, tglx@linutronix.de, hpa@zytor.co,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 06/11] PAT x86: Refactoring i386 cpa
Message-ID: <20080114164736.GI15542@elte.hu>
References: <20080110184840.927409000@intel.com> <20080110184855.677758000@intel.com> <p73bq7to68k.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73bq7to68k.fsf@bingen.suse.de>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> venkatesh.pallipadi@intel.com writes:
> 
> > This makes 32 bit cpa similar to x86_64 and makes it easier for 
> > following PAT patches.
> 
> Please don't do this -- that would be a nightmare merging with my CPA 
> series.
> 
> This means adding the _addr() entry point is ok (although it should 
> not be needed on i386 because it doesn't do the end_pfn_mapped trick), 
> but not a wide scale refactoring.

yeah, i think we can unify after your cpa fixes and enhancements just 
fine - as you did the changes symmetrically for 32-bit and 64-bit. 
Hopefully i'll be able to upload the current PAT stuff in x86.git later 
today so that you can merge the cpa items ontop of it.

	Ingo
