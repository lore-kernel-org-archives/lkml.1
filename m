Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbYFLJf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbYFLJf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYFLJfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:35:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51452 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYFLJfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:35:14 -0400
Date: Thu, 12 Jun 2008 11:34:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, the arch/x86 maintainers <x86@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 GART: Add resume handling (was: Re: >3G => iommu
	=> suspend problems -- was Re: SB600 AHCI: Hard Disk Corruption)
Message-ID: <20080612093430.GA641@elte.hu>
References: <1211717435.6038.53.camel@localhost.localdomain> <20080609124630.GA28799@elte.hu> <200806100010.49194.rjw@sisk.pl> <200806101203.01836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806101203.01836.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Okay, appended is the patch rebased on tip/x86/gart with (mainline) 
> > commit cd76374e9de4501acc74f833dc6cb5e7a5dca115 "suspend-vs-iommu: 
> > prevent suspend if we could not resume" (which appears to be missing 
> > from tip/x86/gart) applied.
> > 
> > This version of the patch doesn't break compilation, but it hasn't 
> > been really tested yet.
> 
> Now it has been (successfully) tested too. :-)

applied to tip/x86/gart, thanks Rafael.

	Ingo
