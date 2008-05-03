Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbYECI3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbYECI3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 04:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYECI3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 04:29:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYECI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 04:29:04 -0400
Date: Sat, 3 May 2008 10:28:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
Message-ID: <20080503082849.GA29605@elte.hu>
References: <200805022053.24779.elendil@planet.nl> <1209756423.4693.8.camel@marge.simson.net> <1209758186.6929.18.camel@lappy> <20080502.144827.158329188.davem@davemloft.net> <1209766054.6929.29.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209766054.6929.29.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Yeah, I was thinking of a way for architectures to signify how much 
> help they need building the various clocks. Sparc, power and s390 
> would not need any help.

there's already such a mechanism in sched-devel.git (and has been there 
for a week or two): an architecture can set time_sync_thresh to -1LL 
during early bootup and essentially disable all the synchronization 
logic.

	Ingo
