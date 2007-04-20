Return-Path: <linux-kernel-owner+w=401wt.eu-S1767183AbXDTScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767183AbXDTScZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767180AbXDTScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:32:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767178AbXDTScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:32:23 -0400
Date: Fri, 20 Apr 2007 20:31:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ego@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070420183118.GA695@elte.hu>
References: <20070419120131.GB13435@in.ibm.com> <200704201054.38037.rjw@sisk.pl> <20070420110520.GB11290@in.ibm.com> <200704201359.30490.rjw@sisk.pl> <20070420122609.GA22325@in.ibm.com> <20070420103052.686f3c71.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420103052.686f3c71.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > I mean, we already have four of them (PF_NOFREEZE, PF_FROZEN, 
> > > PF_FREEZER_SKIP, TIF_FREEZE), and you will need to introduce two 
> > > more for the freezer-based CPU hotplug, so if yet another one is 
> > > needed, that will make up almost a separate u8 field ...
> > 
> > I am perfectly ok with it. But I am not sure if everybody would 
> > agree to have another field in the task struct, though in this case 
> > it does make sense :-)
> 
> OK by me.  You might want to consider making that fields's locking 
> protocol be set_bit(), clear_bit(), etc rather than task_lock().

is OK to me too, the extra field isnt a problem.

	Ingo
