Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZD1KtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZD1KtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZD1KtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:49:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZD1KtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:49:03 -0400
Date: Tue, 28 Apr 2009 12:48:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       hpa@c2micro.com, tglx@linutronix.de, hpa@linux.intel.com,
       jeremy.fitzhardinge@citrix.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: linker script: avoid ALIGN statements
	inside output sections
Message-ID: <20090428104825.GA25347@elte.hu>
References: <tip-c707f31e2e6af2d37bc742c31be0c7e96946c71f@git.kernel.org> <20090428081455.GA19736@elte.hu> <20090428083804.GB17622@uranus.ravnborg.org> <20090428090211.GD26487@elte.hu> <20090428100023.GA18148@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428100023.GA18148@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > 
> > Below is hpa's fix merged up by me on top of your cleanups. That 
> > merge-up is incomplete as we lose these fixlets.
> > 
> > And in this form it's visible how we lose those cleanups you did - 
> > which werent really cleanups ... Please keep such side-effects apart 
> > from truly mechanic cleanups, whenever possible - it makes life 
> > really simpler.
> 
> The cleanup that you applied did NOT move any ALIGN() - or
> at least not on purpose.
> It was supposed to be a noop from a functionality point of view.

yeah - indeed - i mis-interpreted your statement.

> I have started to unify the the two vmlinux.lds files for
> 32 and 64 bit - and as part of that serie (yet to be published) you will
> see individual commits where ALING() is moved and secitons
> are reordered etc.
> I do this in baby steps so we can track regressions using bisect.
> 
> The work is done on top of x86/kbuild and I will rebase as needed 
> when I have it ready.

Cool :)

	Ingo
