Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbXFVOQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbXFVOQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXFVOP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:15:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21657 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbXFVOPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:15:55 -0400
Date: Fri, 22 Jun 2007 14:46:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
cc: Marc Pignat <marc.pignat@hevs.ch>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] mmc-atmel : fix kunmap wrong usage
In-Reply-To: <467BCFCF.6020509@rfo.atmel.com>
Message-ID: <Pine.LNX.4.64.0706221442240.3435@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <200706211657.49427.marc.pignat@hevs.ch>
 <467A9F43.1050007@rfo.atmel.com> <200706220828.18750.marc.pignat@hevs.ch> 
 <Pine.LNX.4.64.0706221237330.26363@blonde.wat.veritas.com>
 <467BCFCF.6020509@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYW5kcmV3QHNhbnBlb3BsZS5jb20Abmljb2xhcy5mZXJyZUByZm8uYXRtZWwuY29tAGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuYXJtLmxpbnV4Lm9yZy51awBtYXJjLnBpZ25hdEBoZXZzLmNoAGRyemV1c0BkcnpldXMuY3gA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Nicolas Ferre wrote:
> 
> Here:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b9bae3402572dc50a1e084c5b1ae5117918ef0f0

Yup.

> > But it would be good to hear from Nicolas whether that indeed fixes
> > his oops: I couldn't actually try my patch on ARM either.
> 
> Ok tested on Atmel ARM AT91 (at91sam9263), this fixes this oops.

Great.

> 
> Thanks a lot to all of you for your precise help.

Not at all, thank you for reporting and testing and reporting back,
in time for 2.6.22: that's all more valuable than the easy fix.

Hugh
