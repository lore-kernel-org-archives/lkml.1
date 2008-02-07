Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYBGJAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYBGJAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYBGJAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:00:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbYBGJAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:00:41 -0500
Date: Thu, 7 Feb 2008 10:00:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, jesse.barnes@intel.com,
       ak@suse.de
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb
	mtrrs - FIX
Message-ID: <20080207090024.GA12884@elte.hu>
References: <200802071257.51893.balajirrao@gmail.com> <20080207080245.GA28631@elte.hu> <86802c440802070056o215e97b0u945a08b12dca8d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802070056o215e97b0u945a08b12dca8d2@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> then title for patch is not right
> > >     x86, 32-bit: trim memory not covered by wb mtrrs
> 
> should be
> 
> x86_64: trim memory not covered by wb mtrrs

indeed :) Although further reading into the commit clearly tells us that 
this is 64-bit only for the time being.

> anyway, we can not modify git log in linux-2.6.git. can we?

yeah, linux-2.6.git is append-only.

	Ingo
