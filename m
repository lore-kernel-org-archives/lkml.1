Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbYD2PZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbYD2PZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYD2PZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:25:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYD2PZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:25:11 -0400
Date: Tue, 29 Apr 2008 17:23:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] toshiba: Use ioremap_cached
Message-ID: <20080429152312.GB19410@elte.hu>
References: <20080429142023.093bfba6@core> <20080429141559.GB26461@elte.hu> <20080429081408.c9dc6b4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429081408.c9dc6b4f.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Acked-by: Ingo Molnar <mingo@elte.hu>
> > 
> > i suspect this shouldnt go via x86.git but i've queued it up to 
> > track it.
> 
> Please don't "queue things up to track them".  Just queue them up to 
> merge them, or don't queue them at all.
> 
> Because if you queue it up then I will not.  If you later for some 
> reason unqueue it then volia, it is lost.  We should aim to avoid 
> having multiple copies of a patch sitting around the place.

but ... i dont just unqueue 'for some reason and then volia'. If we did 
that we'd be losing patches left and right. Every patch we unqueue 
happens in a very predictable protocol that should avoid patches getting 
lost.

( basically we only remove any patch when they are broken but even then
  there's a clear notification. Even a NAK or other fatal review 
  feedback does not actually remove a patch in the typical case when the 
  patch otherwise has practical use, and update is hoped for and the 
  patch does not break things - it just freezes the patch at the "must 
  not go upstream yet" end of the queue. )

if we lose any patches then let us know so we can improve the protocol.

> I shall not merge this patch - it is yours.
> 
> > Is there an active maintainer for this file?
> 
> drivers/char/*?  Very rarely maintained.  git-whatchanged tells the 
> story on this one: no.

ok, we'll push it upstream via x86.git after some test period.

	Ingo
