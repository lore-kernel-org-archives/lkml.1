Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZBIJHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZBIJHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZBIJHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:07:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZBIJHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:07:31 -0500
Date: Mon, 9 Feb 2009 10:07:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: fix a build breakage on latest -tip
Message-ID: <20090209090727.GD31890@elte.hu>
References: <20090208235838.GA4729@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208235838.GA4729@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> A recent conflict resolve (c2eefa20c3ab45ab2108ce7e6561364ea92d7334)
> did put twice the function suspend_test() on kernel/power/main.c
> 
> The version added for CONFIG_PM_TEST_SUSPEND to solve the conflict overlaps
> the one changed recently on (091d71e023557136e96f0e54f301497a3fc95dc3)
> since PM_TEST_SUSPEND depends on SUSPEND.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

This conflict existed for about 10 minutes until automation caught it :)
Latest tip/master is fine, right?

	Ingo
