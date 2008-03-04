Return-Path: <linux-kernel-owner+w=401wt.eu-S1763214AbYCDK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763214AbYCDK2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYCDK21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:28:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbYCDK21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:28:27 -0500
Date: Tue, 4 Mar 2008 11:28:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v3
Message-ID: <20080304102804.GA17681@elte.hu>
References: <20080303230335.892214000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303230335.892214000@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Split the FPU save area from the task struct. This allows easy 
> migration of FPU context, and it's generally cleaner. It also allows 
> the following two optimizations:

hm, i didnt get a reply from you to:

    http://lkml.org/lkml/2008/3/3/47

I'm uneasy to apply patches without knowing whether previous problems 
are fixed. In the changelog there's a mention of:

  v3: Fixed the non-atomic calling sequence in atomic context.

is that the same bug?

	Ingo
