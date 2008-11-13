Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYKMXLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYKMXLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbYKMXL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:11:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58345 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbYKMXLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:11:24 -0500
Date: Fri, 14 Nov 2008 00:11:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] tracing: fix a build error on alpha
Message-ID: <20081113231118.GA23539@elte.hu>
References: <4906D0AE.7020903@gmail.com> <b6fcc0a0811131452x6531f52dg79845c9f6da1c561@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0811131452x6531f52dg79845c9f6da1c561@mail.gmail.com>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Oct 28, 2008 at 11:43 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > +#include <linux/irqflags.h>
> 
> Already fixed.

Note that it's already fixed because the patch you are replying to 
(and which was sent 16 days ago) is already upstream:

  21798a8: tracing: fix a build error on alpha

	Ingo
