Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYIWLdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYIWLdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYIWLd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:33:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbYIWLd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:33:26 -0400
Date: Tue, 23 Sep 2008 13:33:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/2] corruption check: run the corruption checks from a
	work queue
Message-ID: <20080923113303.GA14840@elte.hu>
References: <20080920203544.53a5148e@infradead.org> <20080922140402.166de1ba@infradead.org> <20080922140503.5f3a3db3@infradead.org> <20080922162426.2a55a722@infradead.org> <Pine.LNX.4.64.0809221627290.4768@shark.he.net> <20080922163914.2cafd797@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922163914.2cafd797@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 22 Sep 2008 16:28:23 -0700 (PDT)
> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
> 
> > On Mon, 22 Sep 2008, Arjan van de Ven wrote:
> > 
> > > eh a stray debug // snuck in; update attached
> > 
> > In that case, patch 1/2 contains "for(" and "while(".  :(
> > 
> 
> that's a dillema case.
> I'm just moving code around in patch 1/2; I personally consider it bad
> form to also change it at the same time.....
> 
> (and it confuses git change tracking)

correct. The right solution in this case (where code is moved around) to 
do a separate patch for the style errors Randy reported, once the code 
has been moved over.

	Ingo
