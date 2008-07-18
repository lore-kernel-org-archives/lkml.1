Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbYGRUUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbYGRUUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYGRUUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:20:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYGRUUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:20:07 -0400
Date: Fri, 18 Jul 2008 22:19:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       jbarnes@virtuousgeek.org, Jack Howarth <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080718201953.GB24122@elte.hu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <4880D684.7020406@zytor.com> <86802c440807181047y4ef2f227me72e6474e726596@mail.gmail.com> <4880D7B9.8000007@zytor.com> <86802c440807181054p422a77bdv901ebdc44a8d1b43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807181054p422a77bdv901ebdc44a8d1b43@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > That would make sense, since you're truncating the mmconf range 
> > based on some arbitrary limit.  Even better would be to query the 
> > hardware register which is responsible for the truncation.
> 
> OK
> 
> will rework pci_mmcfg_reject_broken to reduce size and check with 
> is_acpi_reserved/e820_mapped to update end_bus_number

should we apply your current patch (because that is what got tested by 
Jack), with a followup patch - or would you like to send a new patch 
from scratch?

	Ingo
