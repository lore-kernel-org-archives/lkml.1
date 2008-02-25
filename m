Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYBYHlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYBYHlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYBYHlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:41:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48324 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbYBYHlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:41:20 -0500
Date: Mon, 25 Feb 2008 08:40:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EFI_PAGE_SHIFT fix
Message-ID: <20080225074059.GI11327@elte.hu>
References: <1203923917.4707.58.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203923917.4707.58.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> Make x86 EFI code works when EFI_PAGE_SHIFT != PAGE_SHIFT. The 
> memrage_efi_to_native() provided in this patch can be used on other 
> EFI platform such as IA64 too.
> 
> This patch has been tested on Intel x86_64 platform with EFI 64/32 
> firmware.

this is mostly cosmetic, isnt it - because currently nobody expects 
EFI_PAGE_SHIFT and PAGE_SHIFT to ever change on x86, right? I've queued 
up your patch for 2.6.26, ok?

	Ingo
