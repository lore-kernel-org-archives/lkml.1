Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYCDIUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYCDIUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYCDIUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:20:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYCDIUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:20:37 -0500
Date: Tue, 4 Mar 2008 09:20:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, hpa@zytor.com, tglx@linutronix.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v3
Message-ID: <20080304082022.GC5689@elte.hu>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080304011849.GA22431@infradead.org> <20080304013649.GB28006@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304013649.GB28006@linux-os.sc.intel.com>
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

> > Also this weak linkage stuff creaping in is really ugly.
> 
> hmm.. any better suggestion?

i dont find it ugly at all - it's far easier to read than an #ifdef 
maze. And the fact that it's marked "weak" is enough of a visual warning 
IMO that this is just default behavior and that the arch might have 
overriden it.

	Ingo
