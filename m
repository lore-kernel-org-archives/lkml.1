Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXAaJBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXAaJBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbXAaJBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:01:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXAaJBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:01:43 -0500
Date: Wed, 31 Jan 2007 09:59:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH 06/23] timekeeping: create kernel/time/timekeeping.c
Message-ID: <20070131085948.GA17473@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033804.860354489@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033804.860354489@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4953]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Move the generic timekeeping code from kernel/timer.c to 
> kernel/time/timekeeping.c. [...]

please lets not do this just yet. While i have no problems with the 
change in theory, the time code is in high flux and it's easier to keep 
things sorted if we dont do big code movements. It also makes it harder 
to review things and it acts as a hard merge barrier. We usually do such 
move chunks of code in 'quiet periods', and now is definitely not such a 
period. It's also pretty easy to do.

	Ingo
