Return-Path: <linux-kernel-owner+w=401wt.eu-S934545AbZDCPPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545AbZDCPPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934342AbZDCPPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:15:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567AbZDCPPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:15:08 -0400
Date: Fri, 3 Apr 2009 17:14:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/2] decouple interrupt remapping from x2apic
Message-ID: <20090403151433.GA31411@elte.hu>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A5@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A2F7C3A5@pdsmsx503.ccr.corp.intel.com>
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


* Han, Weidong <weidong.han@intel.com> wrote:

> Current interrupt remapping is only enabled when x2apic is 
> enabled. In fact, interrupt remapping can be used without x2apic.
> 
> This patchset decouples interrupt remapping from x2apic, and then 
> interrupt remapping can be used without x2apic.

Acked-by: Ingo Molnar <mingo@elte.hu>

David, mind picking these up into your intel-iommu tree? I suspect 
you have access to hw to test this too.

	Ingo
