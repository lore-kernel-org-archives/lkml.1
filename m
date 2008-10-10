Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbYJJOPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbYJJOPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbYJJOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:15:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295AbYJJOP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:15:28 -0400
Date: Fri, 10 Oct 2008 16:15:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Jenkins <aj504@student.cs.york.ac.uk>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] Tracing/fastboot: Enable boot tracing only during
	initcalls
Message-ID: <20081010141519.GA21104@elte.hu>
References: <20081010103615.EFB18D1BB8F@perso1.free.fr> <20081010105819.GA4699@elte.hu> <c62985530810100402of7e1b48n4aac01d69433c1f5@mail.gmail.com> <20081010110445.GA12519@elte.hu> <48EF50B1.8070705@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EF50B1.8070705@tuffmail.co.uk>
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


* Alan Jenkins <aj504@student.cs.york.ac.uk> wrote:

> > dont worry, i fixed them already when i applied your patch (and 
> > that's all in latest tip/master).
> > 
> > See the commit below - i sanitize most commit entries to make 
> > subject lines more consistent (note the capitalization difference 
> > between your submission and the end result), to improve paragraphing 
> > and general structure.
> 
> You missed the one backslash though...
> 
> > -/* Should be started after do_pre_smp_initcalls() in init/main.c */
> > +/* Tells the boot tracer that the pre_smp_initcalls are finished.
> > + * So we are ready .
> > + * It doesn\'t enable sched events tracing however.
> > + * You have to call enable_boot_trace to do so.
> > + */

heh, indeed - fixed it. ( And there was a second backslash too, 
introduced earlier. ;-)

	Ingo
