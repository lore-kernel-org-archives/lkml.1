Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYAOIoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYAOIoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYAOIog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:44:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYAOIog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:44:36 -0500
Date: Tue, 15 Jan 2008 09:44:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap
Message-ID: <20080115084417.GA16449@elte.hu>
References: <1200375902.3505.29.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200375902.3505.29.camel@caritas-dev.intel.com>
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

> This patchset replaces boot_ioremap with a enhanced version of 
> bt_ioremap and renames the bt_ioremap to early_ioremap. This reduces 
> 12k from .init.data segment and increases the size of memory that can 
> be re-mapped before paging_init to 64k.

in latest x86.git#mm there's an early_ioremap() introduced as part of 
the PAT series - available on both 32-bit and 64-bit. Could you take a 
look at it and use that if it's OK for your purposes?

	Ingo
