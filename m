Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYAHWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYAHWWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYAHWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:22:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYAHWWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:22:25 -0500
Date: Tue, 8 Jan 2008 23:18:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: ananth@in.ibm.com, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       mhiramat@redhat.com, davem@davemloft.net, hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080108221802.GD21482@elte.hu>
References: <20080108063334.GA29385@in.ibm.com> <p73zlvgowwn.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73zlvgowwn.fsf@bingen.suse.de>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Ananth N Mavinakayanahalli <ananth@in.ibm.com> writes:
> >  kernel/kprobes.c        |    2 
> >  kernel/test_kprobes.c   |  216 ++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Can you put this somewhere else please? I know there are already some 
> test files in kernel/* but imho they all belong into some other 
> directory.

agreed - lib/* would be the right place i think - we've got 
lib/locking-selftest.c already.

	Ingo
