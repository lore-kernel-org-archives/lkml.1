Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZBEO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZBEO2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZBEO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:28:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZBEO2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:28:23 -0500
Date: Thu, 5 Feb 2009 15:28:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: __supported_pte_mask breaks PROT_NONE pages
Message-ID: <20090205142802.GD28443@elte.hu>
References: <498A5002.9080408@goop.org> <498A7BE3.40405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A7BE3.40405@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> [Dropped wli from the Cc: list because holomorphy.com doesn't resolve]
> 
> Jeremy Fitzhardinge wrote:
> > 
> > I guess the best fix is to only apply __supported_pte_mask to present
> > ptes.  This seems like the right solution to me, as it means we can
> > completely ignore the issue of overlaps between the present pte bits and
> > the non-present pte-as-swap entry use of the bits.  (Patch below.)
> > 
> 
> It certainly looks reasonable, so I have applied this patch to
> tip:x86/urgent.  However, since I'm on the way out to FOSDEM I won't be
> able to run any tests on this.

Looks good here so i pushed it out into tip:master.

Thanks,

	Ingo
