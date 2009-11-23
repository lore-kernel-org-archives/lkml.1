Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZKWIfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZKWIfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZKWIfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:35:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZKWIfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:35:16 -0500
Date: Mon, 23 Nov 2009 09:34:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size
 config options
Message-ID: <20091123083459.GB11443@elte.hu>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
 <20091116041407.GB5818@wotan.suse.de>
 <4B011677020000780001FD9D@vpn.id2.novell.com>
 <20091116105657.GE5818@wotan.suse.de>
 <20091119035640.GA18236@elte.hu>
 <20091118205240.11d3d660@infradead.org>
 <20091119081307.GA20534@wotan.suse.de>
 <20091119075958.2cba15f8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119075958.2cba15f8@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 19 Nov 2009 09:13:07 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> > 
> > My other point was just this, but I don't care too much. But it is
> > worded pretty negatively. The key here is that increasing the value
> > too large tends to only cost a very small amount of size (and no
> > increase in cacheline foot print, only RAM). 
> 
> 128 has a pretty significant impact on TPC-C benchmarks.....
> it was the top issue until mainline fixed it to default to 64

Mind sending a patch that sets the default to 64 on NUMA too?

P4 based NUMA boxes are ... a bad memory to be forgotten.

	Ingo
