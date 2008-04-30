Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbYD3MgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbYD3MgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYD3Mfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:35:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbYD3Mft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:35:49 -0400
Date: Wed, 30 Apr 2008 14:35:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080430123536.GD30735@elte.hu>
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu> <20080430064603.GA3602@atjola.homenet> <20080430093233.GD23528@elte.hu> <20080430121738.GA4559@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430121738.GA4559@atjola.homenet>
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


* Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> On 2008.04.30 11:32:33 +0200, Ingo Molnar wrote:
> > Automating Sparse runs so that it can become part of our daily 
> > patch-flow is _not_ trivial and it's not just a matter of typing 
> > make C=1. Thomas is working on integrating Sparse delta analysis 
> > into our daily patch workflow nevertheless.
> 
> Who said daily? More often can be better, but just before the pull 
> request is still better than nothing. [...]

Suffice to say that the number of large subsystems that actually run 
Sparse before each and every pull request is extremely low - this simply 
matches the practical difficulties involved.

You are suggesting ad-hoc solutions without having tried it all 
yourself. And i'd very much agree with doing an upstream kernel Sparse 
sweep shortly before the final release. Do you volunteer for that?

We for one simply concentrate on the the things that we think makes it 
more likely to find bugs. For example we build and boot x86.git with 
many different configs before every pull request. In practice that 
catches far more tester-critical bugs than Sparse - and we know that 
simply from the fact because we use both methods and have a good 
comparison of the results. We also work on automating Sparse checks in 
the future but as i said it, it's not easy.

	Ingo
