Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbYBRE3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbYBRE3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYBRE3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:29:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbYBRE3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:29:20 -0500
Date: Mon, 18 Feb 2008 05:28:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, aneesh.kumar@in.ibm.com, efault@gmx.de
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080218042831.GJ30201@elte.hu>
References: <20080130135609.GA5100@ics.muni.cz> <20080214165551.GA21963@linux.vnet.ibm.com> <20080217202642.GA4327@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217202642.GA4327@ics.muni.cz>
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


* Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> On Thu, Feb 14, 2008 at 10:25:51PM +0530, Srivatsa Vaddagiri wrote:
> > The patch is against 2.6.25-rc1. I would request you to check for
> > difference it makes with CONFIG_FAIR_GROUP_SCHED and
> > CONFIG_FAIR_USER_SCHED turned on.
> 
> well, I tried the patch against 2.6.25-rc2-git1. It seems to be better 
> but without CONFIG_FAIR_GROUP_SCHED it is still even better.

could you try latest sched-devel.git, does it behave any better? It 
includes patches from Peter Zijlstra that should also address latencies 
under the group scheduler:

  http://people.redhat.com/mingo/sched-devel.git/README

	Ingo
