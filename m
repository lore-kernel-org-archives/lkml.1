Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYABMej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYABMej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYABMe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:34:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYABMe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:34:28 -0500
Date: Wed, 2 Jan 2008 13:33:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Quentin Barnes <qbarnes@gmail.com>, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] [CFT] Code clarification patch to Kprobes arch code
Message-ID: <20080102123355.GB11208@elte.hu>
References: <b70efdcb0712310929y1bf871eah2adb531a7ed89673@mail.gmail.com> <20080101151943.GE4434@elte.hu> <20080102044353.GA7027@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102044353.GA7027@in.ibm.com>
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


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> > Signed-off-by: Quentin Barnes <qbarnes@gmail.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Tested on x86.
> 
> Acked-by: Ananth N Mavinakayahanalli <ananth@in.ibm.com>

thanks Ananth, i've updated the patch.

btw., do you have some script that i could use to test kprobes 
functionality? Right now the only time i notice kprobes regressions is 
when randconfig picks up CONFIG_NET_TCPPROBE=y which activates kprobes.

It would be so much nicer if kprobes had some runs-during-bootup kind of 
quick self-test, with all the important functionality unit-tested. Like 
lib/locking-selftest.c, or CONFIG_RCU_TORTURE_TEST=y.

	Ingo
