Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbYFXLIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbYFXLIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYFXLIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:08:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37909 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYFXLIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:08:35 -0400
Date: Tue, 24 Jun 2008 13:08:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 0/7] x86: pat.c: reserve_memtype strip down
Message-ID: <20080624110820.GB8695@elte.hu>
References: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> This patch set will (first of all) cleanup reserve_memtype a little 
> bit to make it easier to read and maintain.
> 
> (... and hopefully it doesn't break anything.;-)

applied to tip/x86/pat - thanks Andreas.

> Instead of sending one large patch I broke it down into several pieces 
> to make it easier to review.

thanks!

A nice splitup not only makes review easier but in the (i know, very 
unlikely ;-) case of breakage it narrows down the problem change. 

It also makes maintenance and integration easier.

Especially for architecture code it is very important to do as small 
changes as possible.

	Ingo
