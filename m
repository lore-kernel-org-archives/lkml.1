Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZJLKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZJLKZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZJLKZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:25:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbZJLKZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:25:41 -0400
Date: Mon, 12 Oct 2009 12:24:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the i7core_edac tree with Linus'
	tree
Message-ID: <20091012102450.GA20051@elte.hu>
References: <20091012142328.710881fe.sfr@canb.auug.org.au> <20091012050534.GC7629@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012050534.GC7629@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Mon, Oct 12, 2009 at 02:23:28PM +1100, Stephen Rothwell wrote:
> > Today's linux-next merge of the i7core_edac tree got a conflict in
> > arch/x86/kernel/cpu/mcheck/mce.c between commit
> > f436f8bb73138bc74eb1c6527723e00988ad8a8a ("x86: EDAC: MCE: Fix MCE
> > decoding callback logic") from Linus' tree and commit
> > 699a7dbe1ffdf4b25c1475e45590b181c3e23087 ("edac_mce: Add an interface
> > driver to report mce errors via edac") from the i7core_edac tree.
> 
> The current way Ingo suggested is using an atomic notifier instead
> from within print_mce to convey MCE info to an EDAC driver, see
> http://marc.info/?l=linux-kernel&m=125455310112745&w=2
> 
> Ingo, what are your plans with that? I'm guessing the .33 timeframe?

yeah, that looks like .33 material. (unless it fixes a regression)
I have queued it up in tip:x86/mce.

Thanks,

	Ingo
