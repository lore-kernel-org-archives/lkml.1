Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZBWPAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZBWPAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZBWO7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:59:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbZBWO7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:59:50 -0500
Date: Mon, 23 Feb 2009 15:59:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix unused variable without softlock detection and
	highmem
Message-ID: <20090223145925.GD3377@elte.hu>
References: <200902231739.51863.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231739.51863.knikanth@suse.de>
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


* Nikanth Karthikesan <knikanth@suse.de> wrote:

> When both CONFIG_DETECT_SOFTLOCKUP and CONFIG_HIGHMEM are not 
> defined avoid defining the constant for one fixing the 'define 
> but not used' warning.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

A variant of this is already fixed a bit differently in 
tip:core/softlockup:

9f8d979: softlockup: move 'one' to the softlockup section in sysctl.c

	Ingo
