Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbYLICqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbYLICqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 21:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYLICqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 21:46:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYLICqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 21:46:02 -0500
Date: Tue, 9 Dec 2008 03:45:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
Message-ID: <20081209024543.GA11538@elte.hu>
References: <20081208215221.GA3954@us.ibm.com> <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org>
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


* James Morris <jmorris@namei.org> wrote:

> On Mon, 8 Dec 2008, Serge E. Hallyn wrote:
> 
> > Documented the currently bogus state of support for CFS user groups with
> > user namespaces.  In particular, all users in a user namespace should be
> > children of the user which created the user namespace.  This is yet to
> > be implemented.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> 
> Applied.

hm, i'd rather carry these in the scheduler tree as we've got some 
changes in this area already and because these are arguably scheduler 
changes:

 Documentation/scheduler/sched-design-CFS.txt |   21 +++++++++++++++++++++
 kernel/user.c                                |    8 +++++++-

the incompleteness of CONFIG_USER_SCHED is not addressed yet.

Ok?

	Ingo
