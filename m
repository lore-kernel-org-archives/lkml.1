Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYHAXW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYHAXW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYHAXWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:22:52 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:36915 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYHAXWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:22:51 -0400
Date: Sat, 2 Aug 2008 01:22:42 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Richard Purdie <rpurdie@rpsys.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Move triggers before drivers in Makefile
In-Reply-To: <alpine.LNX.1.10.0808012344090.2294@titan.stealer.net>
Message-ID: <alpine.LNX.1.10.0808020120290.2294@titan.stealer.net>
References: <alpine.LNX.1.10.0808012344090.2294@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 01 Aug 2008 23:22:50 +0000
	Bayes: 0.1441 Tokens: new, 146; hammy, 2; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1441]
X-Spam-Signature: a8efd9044424f68989115984e351256d34beb4b7
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, Sven Wegener wrote:

> When both triggers and drivers are built-in, we should first register the
> triggers and then the drivers, to make default triggers work during device
> registration. We do this by moving the triggers before the drivers in the
> Makefile as init order is determined by linking order. Sadly this simple
> solution doesn't cover devices registered elsewhere in the kernel. But often
> these drivers provide their own triggers and should themselves take care of
> registering triggers before devices.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>

Ignore this one, we also attach default triggers to devices while loading 
the triggers.

Sven
