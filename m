Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYBCVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYBCVQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYBCVQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:16:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59369 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYBCVP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:15:59 -0500
Date: Sun, 3 Feb 2008 22:15:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/4] x86 PM: Consolidate suspend and hibernation code
Message-ID: <20080203211519.GA27737@elte.hu>
References: <200802032141.56887.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802032141.56887.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This series of patches consolidates the x86 suspend and hibernation code.
> It does the following:
> - move 64-bit hibernation/suspend files to arch/x86/power (under different
>   names)
> - rename 32-bit files in arch/x86/power in line with the 64-bit files
> - separate hibernation-specific 64-bit code from the code used for both
>   suspend and hibernation and simplify the Makefile
> - fix up comments
> Details are in the changelogs.
> 
> These patches don't introduce any functional changes.

looks sane to me - i've applied them to x86.git. Is it fine with you if 
we push them upstream (barring any test failures)?

	Ingo
