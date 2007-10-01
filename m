Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbXJAOr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbXJAOr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbXJAOrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:47:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXJAOrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:47:48 -0400
Date: Mon, 1 Oct 2007 16:47:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sami Farin <safari-kernel@safari.iki.fi>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22.6 + oprofile oops
Message-ID: <20071001144733.GA5975@elte.hu>
References: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi> <p73ejgf6sch.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ejgf6sch.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0264]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > 2007-09-22 13:53:32.527330808 <4>[ 3372.390363] Pid: 7, comm: 
> > events/0 Not tainted 2.6.22.6-cfs-v20.5-64-2 #7
             ^^^^^^^^^^^
> 
> Can you reproduce it with a non tainted kernel without any patches 
> like CFS applied?

the kernel is not tainted, as indicated in the log message above.

> The oops happens because oprofile tries to reference a NULL task in 
> its event buffer for a context switch, which might well be a minor 
> merging mistake or similar in the CFS backport.

CFS does not change that aspect of the oprofile code.

	Ingo
