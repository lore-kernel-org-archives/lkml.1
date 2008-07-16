Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbYGPOq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbYGPOq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760062AbYGPOqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:46:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759893AbYGPOqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:46:13 -0400
Date: Wed, 16 Jul 2008 16:46:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Message-ID: <20080716144602.GB4369@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain> <20080716141805.GB22631@elte.hu> <20080716144106.GD25255@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716144106.GD25255@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jul 16, 2008 at 04:18:05PM +0200, Ingo Molnar wrote:
> > btw., about the technical aspects of the solution, i'm not sure i like 
> > these big #ifdef blocks:
> 
> It's partly the nature of the beast.  There's already several large
> #ifdef blocks in compat_ioctl.c -- CONFIG_NET, CONFIG_VT, 
> #CONFIG_SPARC, etc.  I think what would help is a bit more grouping so 
> #individual blocks get bigger.

yeah, that's OK - but why is scsi.h #ifdef-ed? For example we can 
include blkdev.h without #ifdef CONFIG_BLOCK.

	Ingo
