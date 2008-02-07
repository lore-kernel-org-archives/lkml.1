Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYBGLpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYBGLpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 06:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYBGLpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 06:45:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYBGLpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 06:45:03 -0500
Date: Thu, 7 Feb 2008 12:44:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bisected] Re: [bug] networking broke, ssh: connect to port
	22: Protocol error
Message-ID: <20080207114444.GA387@elte.hu>
References: <20080206133506.GA21202@elte.hu> <657224.72762.qm@web36615.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <657224.72762.qm@web36615.mail.mud.yahoo.com>
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


* Casey Schaufler <casey@schaufler-ca.com> wrote:

> > So unlike some other security modules like SELINUX, enabling SMACK 
> > breaks un-aware userspace and breaks TCP networking?
> > 
> > I dont think that's expected behavior - and i'd definitely like to 
> > enable SMACK in automated tests to check for regressions, etc.
> 
> As Stephen mentions later, Smack uses CIPSO. sshd does not like any IP 
> options because of traceroute, and must be built with that check 
> disabled with the current Smack version. I have been looking at using 
> unlabeled packets for the "ambient" label, it appears that doing so 
> would make life simpler. I will get right on it.

ok - feel free to send me any patches to test.

	Ingo
