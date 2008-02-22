Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbYBVJg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbYBVJg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbYBVJgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:36:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55118 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYBVJgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:36:46 -0500
Date: Fri, 22 Feb 2008 10:36:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
Message-ID: <20080222093621.GG327@elte.hu>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au> <20080222075950.GB2660@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222075950.GB2660@uranus.ravnborg.org>
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

> > This is on an x86_64 system (actually an Intel SDV -- so it might be 
> > "special").
>
> This is a regression. Can you please revert this commit. We can redo 
> it wehn the -fstack-protector stuff are properly fixed in x86.

No!

James, could you please check whether x86.git#testing:

   http://people.redhat.com/mingo/x86.git/README

works fine for you? That has all the current stackprotector fixes. I 
plan to send a separate pull request with just the stackprotector fixes 
to Linus, they are looking good in testing so far.

	Ingo
