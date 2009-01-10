Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZAJK6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZAJK6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 05:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZAJK6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 05:58:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZAJK6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 05:58:32 -0500
Date: Sat, 10 Jan 2009 11:58:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: parag.lkml@gmail.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix net/irda build breakage
Message-ID: <20090110105827.GA9460@elte.hu>
References: <alpine.LFD.2.00.0901091829270.21215@localhost.localdomain> <20090109.170258.169849917.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109.170258.169849917.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Parag Warudkar <parag.lkml@gmail.com>
> Date: Fri, 9 Jan 2009 18:30:58 -0500 (EST)
> 
> > commit af0490810cfa159b4894ddecfc5eb2e4432fb976 breaks build for net/irda -
> > 
> > drivers/net/irda/donauboe.c: In function 'toshoboe_interrupt':
> > drivers/net/irda/donauboe.c:1197: error: 'struct toshoboe_cb' has no member named 'stats'
> > drivers/net/irda/donauboe.c:1201: error: 'struct toshoboe_cb' has no member named 'stats'
> > drivers/net/irda/donauboe.c:1283: error: 'struct toshoboe_cb' has no member named 'stats'
> > make[3]: *** [drivers/net/irda/donauboe.o] Error 1
> > make[2]: *** [drivers/net/irda] Error 2
> > 
> > Fix this.
> > 
> > Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
> 
> Already fixed in the net-2.6 GIT tree, but thanks.

mind sending the patch here to lkml too so that people can pick it up? 
Current -git is broken with x86 allyesconfig and Parag's patch above is 
whitespace damaged.

	Ingo
