Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYAONTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYAONTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYAONTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:19:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35968 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYAONTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:19:12 -0500
Date: Tue, 15 Jan 2008 14:19:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: minor cleanup for ptrace_32/64
Message-ID: <20080115131902.GA7025@elte.hu>
References: <Pine.LNX.4.64.0801151336570.30034@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801151336570.30034@fbirervta.pbzchgretzou.qr>
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


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

>     x86: minor cleanup
>     
>     - let get_stack_long from ptrace_32 use long (not int) for consistency
>     - make put_stack_long() return void (return value not used anywhere)
>     - add const keyword to args

ptrace*.c has been unified into ptrace.c in x86.git's mm branch. (see 
the instructions below about how to pick up the latest x86.git repo)

	Ingo

--------------{ x86.git instructions }---------->

# Add Linus's tree as a remote
git remote --add linus
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# Add Ingo's tree as a remote
git remote --add x86
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

# With that setup, just run the following to get any changes you
# don't have.  It will also notice any new branches Ingo/Linus
# add to their repo.  Look in .git/config afterwards, the format
# to add new remotes is easy to figure out.
git remote update

