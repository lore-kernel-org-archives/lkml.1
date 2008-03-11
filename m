Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYCKJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYCKJ3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYCKJ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:29:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58251 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYCKJ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:29:11 -0400
Date: Tue, 11 Mar 2008 10:28:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: P6 NOPs again: MPSC?
Message-ID: <20080311092843.GO25110@elte.hu>
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site> <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com> <Pine.LNX.4.64.0803101853090.15511@blonde.site> <47D59743.7040709@zytor.com> <Pine.LNX.4.64.0803102142440.2464@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803102142440.2464@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> (But I've lost my way around here.  A good example of the 32/64 
> confusion is how one has to remember that X86_GENERIC is peculiar to 
> 32-bit, and CPU_GENERIC peculiar to 64-bit.  And CPU_GENERIC is 
> understandably an alternative to the specific 64-bit models, but 
> X86_GENERIC is strangely in addition to the specific 32-bit models.)

yes - this is one of the arbitrary deviations between 32-bit and 64-bit. 
Patches to bring the concepts and names in sync are welcome :-)

	Ingo
