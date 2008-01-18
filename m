Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbYARMui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbYARMui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYARMu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:50:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50779 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbYARMu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:50:28 -0500
Date: Fri, 18 Jan 2008 13:50:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - enhance bt_ioremap
Message-ID: <20080118125007.GM11044@elte.hu>
References: <1200375906.3505.30.camel@caritas-dev.intel.com> <1200646105.17230.28.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200646105.17230.28.camel@cthulhu.hellion.org.uk>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> Shouldn't these, and the rest of the file, be using the PTE accessor 
> macros set_pte,clear_pte etc? The boot_ioremap it replaces seems to 
> have done. Otherwise these patches don't appear to be paravirt_ops 
> clean. I haven't had a chance to investigate fully so this might be a 
> Xen bug or unrelated to this patch but running current x86.git#mm as a 
> Xen guest ends up with it being shot in the head by the hypervisor 
> with:

willing to apply patches.

	Ingo
