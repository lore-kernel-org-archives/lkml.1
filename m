Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYIJIp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYIJIp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYIJIpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:45:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58686 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbYIJIpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:45:11 -0400
Date: Wed, 10 Sep 2008 10:44:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] pci: fix merging left out for BAR print out v2
Message-ID: <20080910084450.GJ15255@elte.hu>
References: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> print out for Device BAR address before kernel try to update them.
> 
> also change it to KERN_DEBUG instead...
> 
> v2: update to linux-pci next
>    also add (unsigned long long) cast
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Jesse, if you want to pick it up, could we please do this via git 
methods (git-pull and stuff)? The commit below is the one in -tip - 
should i separate it out?

	Ingo

----------->
commit ca81beb4a340ee690803fcb1498f863d0e68843f
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Thu Sep 4 20:57:15 2008 +0200

    pci: fix BAR print out

    print out device BAR address before kernel tries to update them.

    also change it to KERN_DEBUG instead...

