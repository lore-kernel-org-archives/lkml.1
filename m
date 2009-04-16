Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbZDPQ67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbZDPQ67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZDPQ6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:58:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbZDPQ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:58:48 -0400
Date: Thu, 16 Apr 2009 18:58:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090416165833.GA21704@elte.hu>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416160645.GB17804@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Alessio Igor Bogani <abogani@texware.it> wrote:
> 
> > Replace ths BKL in sys_mount()/sys_umount() syscalls with a regular mutex.
> > 
> > Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
> > ---
> >  fs/namespace.c |   16 +++++++++-------
> >  fs/super.c     |    9 ++++-----
> >  2 files changed, 13 insertions(+), 12 deletions(-)
> 
> Ok, this patch needs to be flamed^W commented on by Al.
> 
> Al: this patch is very likely broken as i cannot imagine you 
> leaving the BKL there just so. So lets accept that (and your NAK) 
> as a given and not get upset about it too much.
> 
> We are willing to fix any side effects and preconditions before 
> this can be done [...]

this == remove the BKL. Not introduce a needless mutex like this 
patch does.

	Ingo
