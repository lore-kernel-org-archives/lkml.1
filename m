Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbYKYJNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbYKYJNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKYJNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:13:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57251 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYKYJNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:13:07 -0500
Date: Tue, 25 Nov 2008 10:12:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Markus Metzger <markus.t.metzger@intel.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch 7/9] x86, pebs: export ds.c symbols
Message-ID: <20081125091229.GA22027@elte.hu>
References: <20081125090847.A31384@sedona.ch.intel.com> <20081125082603.GB28031@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125082603.GB28031@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Nov 25, 2008 at 09:08:47AM +0100, Markus Metzger wrote:
> > Export symbols in ds.c.
> > 
> > The changes are required to allow perfmon2 to access DS.
> 
> So put them into the perform2 patchset.

yes - and they need to be EXPORT_SYMBOL_GPL() as well.

	Ingo

