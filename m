Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZCVOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZCVOpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZCVOpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:45:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZCVOpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:45:40 -0400
Date: Sun, 22 Mar 2009 15:45:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Markus <M4rkusXXL@web.de>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12872] pwc mmap always fails with EAGAIN
Message-ID: <20090322144516.GA13129@elte.hu>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera> <l8NZ2a3iQtG.A._5H.fZTxJB@chimera> <200903221337.35237.M4rkusXXL@web.de> <20090322142837.2df0d93d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322142837.2df0d93d@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 22 Mar 2009 13:37:35 +0100
> Markus <M4rkusXXL@web.de> wrote:
> 
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me 
> > know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12872
> > > Subject		: pwc mmap always fails with EAGAIN
> > > Submitter	: Markus <M4rkusXXL@web.de>
> > > Date		: 2009-03-14 16:42 (8 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=123704902201378&w=4
> > 
> > Still valid for 2.6.29-rc8-git5.
> 
> And not really likely to change until someone with a pwc camera adds lots
> of printks to the code to work out why this happens.

Or does a bisection to figure out the bad commit, because the report 
says that 2.6.28 worked.

The 'howto bisect' portion of:

  http://www.kernel.org/doc/local/git-quick.html

	Ingo
