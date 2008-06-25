Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYFYQIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYFYQIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYFYQIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:08:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbYFYQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:08:30 -0400
Date: Wed, 25 Jun 2008 18:08:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: lenb@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap v2
Message-ID: <20080625160817.GC24967@elte.hu>
References: <1214333310.27577.26.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214333310.27577.26.camel@promb-2n-dhcp368.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alok Kataria <akataria@vmware.com> wrote:

> This is a preparatory patch for the next patch in series.
> Moves some code from e820_setup_gap to a new function e820_search_gap.
> This patch is a part of a bug fix where we walk the ACPI table to calculate
> a gap for PCI optional devices.
> 
> v1->v2: Patch on top of tip/master.
> 	Fixes a bug introduced in the last patch about the typeof "last".
> 	Also the new function e820_search_gap now returns if we found a gap in
> 	e820_map.

applied to tip/x86/setup-memory - thanks Alok.

should i put the other patch, "acpi based pci gap caluculation v2" into 
tip/out-of-tree for more testing of this new e820 facility?

	Ingo
