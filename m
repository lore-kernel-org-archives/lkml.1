Return-Path: <linux-kernel-owner+w=401wt.eu-S1763166AbYBUGWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763166AbYBUGWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYBUGW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:22:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbYBUGWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:22:25 -0500
Date: Thu, 21 Feb 2008 07:22:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kgdb: fixes and ARCH=arm support
Message-ID: <20080221062215.GA10172@elte.hu>
References: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com>
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


* Jason Wessel <jason.wessel@windriver.com> wrote:

> Here are 3 more patches against the kgdb-light.  Porting kgdb-light to 
> another arch has found 2 regressions, which are fixed in the first 
> patch.
> 
> The second patch adds hooks for an additional kgdboc uart driver which 
> was required to complete the testing with real hardware.
> 
> The third patch adds the ARCH=arm support for kgdb-light.

thanks Jason. I've merged all 3 into the kgdb-light tree to ease 
testing.

I think we should also try to do some self-tests, so that when one boots 
a bzImage with the self-tests activated it can be said that all the 
basic functionality works. Simulated via some loopback method, from 
within the kernel - not via a real serial line - but it should have the 
capability to do real single-stepping and inject real hw breakpoints and 
test that they work. What do you think?

	Ingo
