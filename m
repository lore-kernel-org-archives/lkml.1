Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZBOJxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZBOJxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 04:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZBOJwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 04:52:55 -0500
Received: from mailhost-i2-m1.mangoosta.org ([78.40.49.165]:54435 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbZBOJwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 04:52:54 -0500
Date: Sun, 15 Feb 2009 10:51:28 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215095128.GA3234@localhost.localdomain>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215090026.GA31147@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Load average is between 0.30 and 0.60 when the machine is idle, the
> > two ksoftirqd threads get a very high total running time in top.
> > This is on a P4 machine. On a recent laptop, the load is not as
> > high, but the ksoftirqd threads also get a very high total running
> > time.

> Mind having a look at this anomaly with the function graph tracer? We are
> interested in a representative trace that shows the weird ksoftirq activities.
> [ which trace could possibly pinpoint their origin. ]

> Here's the tracing quickstart:

>    http://redhat.com/~mingo/tip.git/tracing-quickstart.txt

> Also attached below. Let me know if you have trouble getting a good trace,
> or if any of the steps were non-intuitive or burdensome to you.

Thanks for your feedback & explanations; I will try to have a look at
all this material asap, I think tomorrow.

Damien
