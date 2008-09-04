Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYIDLG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYIDLG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYIDLGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:06:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYIDLGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:06:51 -0400
Date: Thu, 4 Sep 2008 13:06:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 1/5] x2apic: fix reserved APIC register accesses in
	print_local_APIC()
Message-ID: <20080904110631.GC8668@elte.hu>
References: <20080904000237.746216000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904000237.746216000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied the following patches tip/irq/sparseirq:

 0f48966: dmar: fix dmar_parse_dev() devices_cnt error condition check
 2283240: dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()
 3f1fdb3: dmar: initialize the return value in dmar_parse_dev()
 f12c73e: dmar: fix using early fixmap mapping for DMAR table parsing
 2c72d93: x2apic: fix reserved APIC register accesses in print_local_APIC()

thanks Suresh!

	Ingo
