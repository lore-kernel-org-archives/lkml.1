Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYBNGMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYBNGMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbYBNGM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:12:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40462 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972AbYBNGMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:12:24 -0500
Date: Thu, 14 Feb 2008 07:12:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080214061203.GA31327@elte.hu>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org> <47B30F05.29637.9A21F9B@pageexec.freemail.hu> <alpine.LFD.1.00.0802130749210.2920@woody.linux-foundation.org> <20080213160148.GA20241@elte.hu> <20080213171614.GA12259@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213171614.GA12259@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > if you're merging this, please do the independent parts really 
> > > independenrly. For example, the above is a patch in its own right, 
> > > and probably worth doing regardless of anything else.
> > 
> > yes. I wanted to have it tested for a bit, because the lack of use 
> > of the gcc flag means complete lack of testing coverage. The 
> > obligatory "please add a stackprotector self-test" debug feature 
> > request went to Arjan two days ago already.
> 
> Do you think that the top-lvel Makefile change is OK to merge? I would 
> like to merge it separatly to have maximum bisectability.

sure.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
