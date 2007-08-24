Return-Path: <linux-kernel-owner+w=401wt.eu-S1765148AbXHXO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765148AbXHXO5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXHXO5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:57:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbXHXO5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:57:43 -0400
Date: Fri, 24 Aug 2007 16:57:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFS + Rhythmbox audio skipping
Message-ID: <20070824145743.GA24701@elte.hu>
References: <pan.2007.08.24.12.15.32@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2007.08.24.12.15.32@telenet.be>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederik Himpe <fhimpe@telenet.be> wrote:

> Some time ago, it was already discussed here that Rhythmbox would 
> easily cause audio skipping when running with the CFS scheduler 
> (http:// bhhdoa.org.au/pipermail/ck/2007-June/007886.html). It was 
> said to be a Rhythmbox problem, for which someone needed to open a bug 
> report. Well, I just did this, but the developer says he cannot 
> reproduce this, and denies that Rhythmbox is making any X calls in its 
> audio playback thread, so this bug is blocked for the moment.
> 
> http://bugzilla.gnome.org/show_bug.cgi?id=467437
> 
> It seems that there are people who know better what is wrong exactly. 
> Can somebody give some more details about what Rhythmbox is doing 
> wrong, either here, either in the bug ticket?

could you first check whether CFS v20.3:

   http://people.redhat.com/mingo/cfs-scheduler/

is it still showing the same symptoms with rhythmbox? If yes, what kind 
of load of yours is typically causing the Rhythmbox skipping? x11perf?

	Ingo
