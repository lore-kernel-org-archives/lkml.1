Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZBBXtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZBBXtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZBBXtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:49:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbZBBXtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:49:40 -0500
Date: Tue, 3 Feb 2009 00:49:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Message-ID: <20090202234923.GA7499@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain> <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain> <200902022239.02453.rjw@sisk.pl> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ingo: how do we walk over all the interrupt descriptors in todays world? 
> The whole sparse-vs-nonsparse makes things a bit more complex.

this:

        struct irq_desc *desc;
        int irq;

        for_each_irq_desc(i, desc) {
	...
	}

should do the trick.

	Ingo
