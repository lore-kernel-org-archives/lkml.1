Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbZEFIvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbZEFIvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZEFIvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:51:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbZEFIvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:51:03 -0400
Date: Wed, 6 May 2009 10:50:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Jack Steiner <steiner@sgi.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
Message-ID: <20090506085045.GB10292@elte.hu>
References: <1241493327.27664.17.camel@ymzhang> <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com> <20090505163608.GA20385@sgi.com> <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> On Tue, 5 May 2009, Jack Steiner wrote:
> 
> > I was able to duplicate your original problem. Your patch below solves the
> > problem. AFAICT, it causes no new reqgressions to the various configurations
> > that I'm testing. (I'll add the "mem=2G" to my configs that I test).
> > 
> 
> Great, it would be helpful to catch these problems before 2.6.30 
> is released.  I've passed my patch along to Ingo.

Good catch - i've queued it up in x86/urgent, thanks!

	Ingo
