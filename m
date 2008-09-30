Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYI3L1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYI3L1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYI3L1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:27:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYI3L1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:27:44 -0400
Date: Tue, 30 Sep 2008 13:27:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2] x86: split out dumpstack code from traps_xx.c
Message-ID: <20080930112728.GD21367@elte.hu>
References: <1222773135-1073-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222773135-1073-1-git-send-email-heukelum@fastmail.fm>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Hi Ingo,
> 
> I intend to keep looking for possibilities to bring traps_32.c and 
> traps_64.c closer to each-other. One trivial way (from my point of 
> view) is to split out code into separate files. These two patches 
> split out a large piece of code that has nothing to do with hardware 
> traps. Are you willing to take those two patches? Or are they to 
> intrusive?

they are not intrusive at all! The right way to do such things is to 
keep them in reasonably small files.

> Patches are against the current master branch of the tip tree. The 
> defconfigs compile fine and I ran some simple configs within qemu.

would be nice to bring dumpstack_32.c and dumpstack_64.c together as 
well. While some of the details like IST stack logic (which dont exist 
on 32-bit) are special, most of the glue, the iterators, the boot 
parameters, and even the output should be unified some more.

	Ingo
