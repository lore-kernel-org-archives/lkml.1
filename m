Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYFYHIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYFYHIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYFYHIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:08:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYFYHIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:08:12 -0400
Date: Wed, 25 Jun 2008 09:07:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Message-ID: <20080625070740.GA8506@elte.hu>
References: <20080620135639.GA5073@damson.getinternet.no> <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain> <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com> <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com> <19f34abd0806210119o64a1c9ban78710651a01530cf@mail.gmail.com> <20080624114139.GC21890@elte.hu> <alpine.LFD.1.10.0806242240050.3014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806242240050.3014@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> > > and now I understand the purpose of the check; pnpbios does not 
> > > depend on ACPI; ACPI/pnpacpi is incompatible with pnpbios.
> > 
> > wow, rather old bug - i guess lockdep made it more visible.
> 
> No, that commit was not a bug, it was correct, and still is, for 
> pnpACPI and pnpBIOS must be mutually exclusive.
> 
> The thing that changed was the RTC specific code.

ok. Vegard's patch/workaround got my test setup going, i'll drop it if 
something better comes along. (tip/out-of-tree commits dont get 
propagated into linux-next so it will not interfere with anything)

	Ingo
