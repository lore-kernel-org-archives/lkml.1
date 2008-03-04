Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbYCDKfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbYCDKfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYCDKfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:35:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbYCDKfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:35:06 -0500
Date: Tue, 4 Mar 2008 11:34:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: early_res and find_e820_area for i386?
Message-ID: <20080304103448.GC17621@elte.hu>
References: <1204601883.4707.96.camel@caritas-dev.intel.com> <47CCCED4.30607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CCCED4.30607@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>> BTW: Why not merge e820_32.c and e820_64.c? At least part of them.
>
> What we *should* do, on both i386 and x86-64, is to create a synthetic 
> e820 table of any non-e820 information, and then yes, we should merge 
> the code.
>
> In other words, we should have an e820 table which reflects what the 
> kernel considers true about the memory space.

i'd strongly support the moving of this from the realm of talk into the 
realm of code! :-)

	Ingo
