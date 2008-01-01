Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYAAP3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYAAP3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYAAP3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:29:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYAAP3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:29:42 -0500
Date: Tue, 1 Jan 2008 16:29:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] get rid of checkpatch.pl complains on apm_32.c
Message-ID: <20080101152931.GH4434@elte.hu>
References: <20071231204753.GA7411@cvg.cvg> <20080101150054.GB4434@elte.hu> <20080101151112.GC7937@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101151112.GC7937@cvg.cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> damn me! *really* sorry for this.

nah, this happens all the time for me too - that's why i run a script 
over cleanup patches.

> Ingo, do you use some script for this checking? if yes - could you 
> share it? ;) (i think it's not really hard to write myown, but your 
> one is really preferred ;)

sure, pick up the script from:

 http://redhat.com/~mingo/misc/q-size-obj-compare

it depends on having the patch in a quilt queue. (and it's really sucky, 
no error checking, etc.)

just run it - it picks up a modified .c file and compares that. If you 
modify multiple files and want to check another one, give that file as 
an argument to the script.

	Ingo

