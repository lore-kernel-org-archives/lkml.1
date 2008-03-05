Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbYCEMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbYCEMoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbYCEMoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:44:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbYCEMoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:44:15 -0500
Date: Wed, 5 Mar 2008 13:43:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-ID: <20080305124348.GB2365@elte.hu>
References: <1204567052.6241.4.camel@lappy> <20080303121033.c8c9651c.pj@sgi.com> <1204568316.8514.18.camel@twins> <20080304013534.4e51ae48.pj@sgi.com> <1204628762.6241.46.camel@lappy> <47CDA885.3000103@qualcomm.com> <20080304191159.a02be58b.pj@sgi.com> <1204706272.6241.79.camel@lappy> <20080305085019.GA24097@elte.hu> <20080305063518.69d03de1.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305063518.69d03de1.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> > i always thought that cpusets should boot up with some meaningful 
> > default set that people could play with.
> 
> They do ... you just have to mount cpusets to see it ;).

the root cpuset is special as it is the root of the tree. You cannot 
shrink it in practice (in a meaningful way) because then you cannot have 
children outside of its scope.

	Ingo
