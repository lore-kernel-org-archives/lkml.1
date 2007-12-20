Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbXLTTGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbXLTTGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbXLTTGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:06:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXLTTF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:05:59 -0500
Date: Thu, 20 Dec 2007 20:04:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
	well
Message-ID: <20071220190419.GA23620@elte.hu>
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200313.54425.volker.armin.hemmann@tu-clausthal.de> <476A8965.40703@s5r6.in-berlin.de> <200712201912.37416.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712201912.37416.volker.armin.hemmann@tu-clausthal.de>
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


* Hemmann, Volker Armin <volker.armin.hemmann@tu-clausthal.de> wrote:

> On Donnerstag, 20. Dezember 2007, you wrote:
> > Hemmann, Volker Armin wrote:
> > > [ 5194.131014] Pid: 22490, comm: sleep Tainted: P        2.6.23.11reiser4
> > > #4
> >
> > The subject line is wrong.
> > You apparently run Linux, but not Linux 2.6.23.y.
> 
> first of all, apart from this oops all other oopses I reported were 
> with a not-tainted kernel. You might want to read the other mails I 
> have sent.
> 
> Also, besides of the reiser4 patch there is no other patch added to 
> the kernel. And since people have had successfully reported problems 
> with heavily distro-patched kernels in the past it looks a little bit 
> hypocritical to put my reports aside because of one single patch - 
> don't you think?

reiser4 isnt just a single random patch, it's a huge patch with lots of 
interactions with file and memory management. Would it be hard for you 
to reproduce the crash without reiser4? (or is all your stuff on 
reiser4?)

	Ingo
