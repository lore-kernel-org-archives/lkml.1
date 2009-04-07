Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZDGFtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZDGFtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZDGFta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:49:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbZDGFt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:49:29 -0400
Date: Tue, 7 Apr 2009 07:48:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
Message-ID: <20090407054818.GA5557@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu> <1239083045.22733.383.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239083045.22733.383.camel@macbook.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2009-04-07 at 07:37 +0200, Ingo Molnar wrote:
> > I suspect these bits are the ones that broke the upstream build:
> > 
> >  drivers/pci/dmar.c:47: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> > ‘__attribute__’ before ‘dmar_tbl_size’
> >  drivers/pci/dmar.c:62: warning: ‘struct acpi_dmar_device_scope’
> > declared inside parameter list
> >  drivers/pci/dmar.c:62: warning: its scope is only this definition or
> > declaration, which is probably not what you want
> 
> Yeah, <acpi/acpi.h> was being included implicitly for me, but 
> certain configs don't do that. Alexander Beregalov sent a patch 
> for that, which I added to my tree before Linus pulled it.
> 
> Commit 46f06b72378d3187f0d12f7a60d020676bfbf332 is the fix.

No, that does not fix it - it's still broken with 
v2.6.29-9854-gd508afb. Try the config i sent.

	Ingo
