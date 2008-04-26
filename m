Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYDZNpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYDZNpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYDZNo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:44:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46525 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYDZNoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:44:55 -0400
Date: Sat, 26 Apr 2008 15:44:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches
Message-ID: <20080426134443.GA28860@elte.hu>
References: <20080426020221.GF5882@ZenIV.linux.org.uk> <20080426110139.GA23867@elte.hu> <20080426133512.GP14990@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426133512.GP14990@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Apr 26, 2008 at 01:01:39PM +0200, Ingo Molnar wrote:
> > 
> > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > >      sanitize unshare_files/reset_files_struct
> > 
> > today's -git started crashing on me in randconfig boot tests:
> > 
> > [    0.124077] BUG: unable to handle kernel NULL pointer dereference at 00000296
> > [    0.126981] IP: [<c01217fb>] put_files_struct+0xb/0xa0
> > [    0.128981] *pdpt = 0000000000f73001 *pde = 0000000000000000
> > [    0.131231] Oops: 0002 [#1] PREEMPT
> 
> Did you have http://lkml.org/lkml/2008/4/26/1 applied?

not yet - will try that. (but i suspect it will fix it)

	Ingo
