Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYCYURk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYCYURk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYCYURd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:17:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYCYURc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:17:32 -0400
Date: Tue, 25 Mar 2008 21:17:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 134/148] include/asm-x86/uaccess_64.h: checkpatch
	cleanups - formatting only
Message-ID: <20080325201719.GF15330@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com> <1206259443-13210-135-git-send-email-joe@perches.com> <20080325152559.GA20898@elte.hu> <1206469767.4845.97.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206469767.4845.97.camel@localhost>
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


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2008-03-25 at 16:25 +0100, Ingo Molnar wrote:
> > hm, you apparently never built this on 64-bit x86?
> 
> Correct. x86(_32) defconfig and allyesconfig only.
> 
> > The above has a trivial typo.
> 
> Careless.
> I'll set up an x86-64 cross-compiler.

yeah - 64-bit allyesconfig (with DEBUG_INFO disabled - it just slows 
down the build) should trigger most of the problems.

nevertheless i have most of your other patches in x86.git/latest right 
now, you can pick it up via:

  http://people.redhat.com/mingo/x86.git/README

> Before building I did
> s/__LINE__/0/g
> to minimize the md5sum differences
> 
> and md5sum/diff and objdump -Dx/diff and inspected
> the objects before and after.

that's a nice trick - i never figured out a good way to skip such type 
of build differences.

	Ingo
