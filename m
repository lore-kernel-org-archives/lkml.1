Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYA0G13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYA0G13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYA0G1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:27:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60287 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYA0G1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:27:19 -0500
Date: Sun, 27 Jan 2008 07:27:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: X fails to start with latest Linus git
Message-ID: <20080127062703.GA23444@elte.hu>
References: <479BCE03.6070603@gmail.com> <479BD1D1.8020503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479BD1D1.8020503@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0031]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> The machine boots normally, but without that revert, X locks up.  Does 
> that make sense to anyone?

could you send your full bootlog? Also please send me the output of:

 http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and please send me your .config as well.

somehow this new ktime_get() done within printk() will lock up your box 
- that's weird. We can undo this commit easily, but it would be nice to 
figure out what's going on.

	Ingo
