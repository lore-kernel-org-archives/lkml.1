Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYAIKrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYAIKrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYAIKr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:47:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYAIKr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:47:26 -0500
Date: Wed, 9 Jan 2008 11:47:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109104711.GA14041@elte.hu>
References: <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de> <478424DE.3030609@goop.org> <20080109014233.GG25945@bingen.suse.de> <478429DE.1090901@goop.org> <20080109021124.GH25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109021124.GH25945@bingen.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> There's one Jan pointed out: iounmap does not subtract the guard page 
> size so it ends up resetting one page too much. That is probably what 
> causes your problem. But again you should be passing in G in the first 
> place.
> 
> -Andi
> 
> Here was Jan's patch; it incidently fixes the G problem too

thanks, applied. I changed:

  From: Andi Kleen <ak@suse.de>

to:

  From: Jan Beulich <jbeulich@novell.com>

	Ingo
