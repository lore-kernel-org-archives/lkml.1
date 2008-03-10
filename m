Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbYCJHlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbYCJHlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYCJHlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:41:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYCJHk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:40:59 -0400
Date: Mon, 10 Mar 2008 08:40:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kgdb: Add kgdb internal test suite
Message-ID: <20080310074047.GA16906@elte.hu>
References: <1204929257-9967-1-git-send-email-jason.wessel@windriver.com> <1204929257-9967-2-git-send-email-jason.wessel@windriver.com> <1204929257-9967-3-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204929257-9967-3-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0027]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> This patch adds regression tests for testing the kgdb core and arch
> specific implementation.

nice!

> When using the "kgdbts=" you only choose one of the following core
> test types:
> A = Run all the core tests silently
> V1 = Run all the core tests with minimal output
> V2 = Run all the core tests in debug mode

please also add a Kconfig way to activate them and let them be executed 
automatically upon bootup. If any test fails it should generate a 
WARN_ON() type of message (for automated testers to find).

	Ingo
