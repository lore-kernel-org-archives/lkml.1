Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYLPTTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYLPTTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYLPTSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:18:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43891 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYLPTSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:18:53 -0500
Date: Tue, 16 Dec 2008 20:18:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Greg Kroah-Hartman <gregkh@suse.de>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable -
	hibernate related
Message-ID: <20081216191827.GA1176@elte.hu>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.bnH.14_QJB@chimera> <b637ec0b0812131045n34bf420w3729abf24533b51c@mail.gmail.com> <200812131956.03495.rjw@sisk.pl> <20081216190707.GA336@elte.hu> <alpine.LFD.2.00.0812161113350.14014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812161113350.14014@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 16 Dec 2008, Ingo Molnar wrote:
> > 
> > yeah - i think it's too late to do anything but a revert here.
> 
> Yup. Already done. Commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325.
> 
> Did -stable revert it too?

not that i know of (-stable tries to follow upstream with reverts too).
We could have put a Cc: stable@kernel.org into the reverter commit ;-)

	Ingo
