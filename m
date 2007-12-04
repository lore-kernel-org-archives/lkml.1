Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbXLDVOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbXLDVOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXLDVIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:08:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32825 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbXLDVII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:08:08 -0500
Date: Tue, 4 Dec 2007 22:07:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86_64: define all _PAGE_* in terms of _PAGE_BIT_*
Message-ID: <20071204210751.GH32018@elte.hu>
References: <11966016811565-git-send-email-joerg.roedel@amd.com> <11966016814058-git-send-email-joerg.roedel@amd.com> <20071204123809.GD27286@elte.hu> <20071204150652.GJ6945@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204150652.GJ6945@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Dec 04, 2007 at 01:38:09PM +0100, Ingo Molnar wrote:
> > 
> > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > +#define _PAGE_PRESENT	(_AC(1,UL)<<_PAGE_BIT_PRESENT)
> > 
> > please run patches through scripts/checkpatch.pl, it gives:
> > 
> >   total: 10 errors, 0 warnings, 42 lines checked
> > 
> > (please send a followup cleanup patch - i picked up your series and this 
> > is a minor cleanliness issue)
> 
> Sorry, forgot to check the patches before submission. Will cleanup and 
> resubmit soon.

please if possible send a delta against x86.git, not a replacement 
patch. It's easier for the patchflow.

	Ingo
