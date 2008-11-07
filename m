Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYKGKA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYKGKA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYKGKAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:00:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYKGKAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:00:15 -0500
Date: Fri, 7 Nov 2008 11:00:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap"
	messages
Message-ID: <20081107100005.GB22545@elte.hu>
References: <200809091250.08620.elendil@planet.nl> <200809091826.18876.elendil@planet.nl> <200809091140.25597.bjorn.helgaas@hp.com> <200811071051.32830.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811071051.32830.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> The most likely cause of this change is the following commit from Linus:
>
> commit 1f98757776eafe31065be9118db6051afcf8643c
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Nov 1 10:17:22 2008 -0700
>     x86: Clean up late e820 resource allocation

Correct.

	Ingo
