Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYKMQIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYKMQIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYKMQIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:08:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47028 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYKMQIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:08:35 -0500
Date: Thu, 13 Nov 2008 17:08:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Doug Chapman <doug.chapman@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Frank Mayhar <fmayhar@google.com>,
       roland@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] revert: timers: fix itimer/many thread hang
Message-ID: <20081113160808.GA13726@elte.hu>
References: <1224694989.8431.23.camel@oberon> <1225132746.14792.13.camel@bobble.smo.corp.google.com> <1225219114.24204.37.camel@oberon> <1225936715.27507.44.camel@bobble.smo.corp.google.com> <1225969420.7803.4366.camel@twins> <1225989102.7803.4749.camel@twins> <1226592021.21297.25.camel@oberon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226592021.21297.25.camel@oberon>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Doug Chapman <doug.chapman@hp.com> wrote:

> Peter didn't mention here that the itimer/many thread patches cause 
> a race-condition panic which is easily reproduced (in fact 
> unavoidable with SLUB debugging on) on hyperthreaded ia64 systems 
> (but certainly possible on all systems).  Can we get this revert 
> patch pulled in?  The other attempts to fix this so far have been 
> unsuccessful.  I have tested with this revert patch and it does 
> indeed fix that issue.

Could you please try with the very latest upstream kernel? It should 
be fixed by Oleg's fix patch via:

ad474ca: fix for account_group_exec_runtime(), make sure ->signal can't be fre

which is already upstream.

	Ingo
