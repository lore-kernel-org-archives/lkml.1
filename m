Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbYC0L7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbYC0L7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYC0L7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:59:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbYC0L7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:59:09 -0400
Date: Thu, 27 Mar 2008 12:58:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, hpa@zytor.com, andi@firstfloor.org,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] x86_64 boot: Add free_early to early
	reservation machanism
Message-ID: <20080327115851.GD13538@elte.hu>
References: <1206601746.3067.21.camel@caritas-dev.intel.com> <20080327063411.8611cd8f.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327063411.8611cd8f.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> Huang wrote:
> > +		panic("free_early on not reserved area: %lx-%lx!", start, end);
> 
> Should that be 'early_panic', not 'panic' ?
> 
> (I see a couple more panics in that file, which I wonder
> if should be early_panic as well ?)

this should be fixed properly btw: panic() should self-select whether it 
does an early_panic() or a real panic().

	Ingo
