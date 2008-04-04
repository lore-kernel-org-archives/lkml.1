Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbYDDNEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbYDDNEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760888AbYDDM6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:58:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760889AbYDDM57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:57:59 -0400
Date: Fri, 4 Apr 2008 14:57:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24 still doesn't boot on i486..
Message-ID: <20080404125743.GB29423@elte.hu>
References: <47F5EE6A.6080705@msgid.tls.msk.ru> <18422.8628.510177.819697@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18422.8628.510177.819697@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

>  > And now I wonder if I'm the only person in this world with i486 
>  > machine... ;)
> 
> Just FYI, 2.6.23, 2.6.24 and 2.6.25-rc6 work fine on my i486DX4.
> 
> However, it's clear from your .config fragment above that you've 
> enabled features that cannot possibly exist on a 486 (APICs and MCE 
> for starters) and there may be bugs related to that. I suggest 
> trimming your .config and making it 486-specific.

apics should be auto-detect though. So if a .24 config was plugged into 
.25 and the kernel broke that's still a regression - would be nice to 
figure out which .config detail causes this problem.

	Ingo
