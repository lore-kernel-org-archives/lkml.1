Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXI1Q5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXI1Q5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXI1Q5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:57:37 -0400
Received: from xenotime.net ([66.160.160.81]:52823 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752310AbXI1Q5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:57:36 -0400
Date: Fri, 28 Sep 2007 09:57:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-Id: <20070928095734.407ad4fc.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.64.0709281617430.25099@fbirervta.pbzchgretzou.qr>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky>
	<20070928093902.GA28455@elte.hu>
	<20070928100024.GB18163@shadowen.org>
	<200709281246.45546.borntraeger@de.ibm.com>
	<20070928110310.GF2443@hacking>
	<Pine.LNX.4.64.0709281617430.25099@fbirervta.pbzchgretzou.qr>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 16:19:01 +0200 (CEST) Jan Engelhardt wrote:

> 
> On Sep 28 2007 19:03, WANG Cong wrote:
> >
> >Maybe checkpatch.pl needs an option '-W' to turn on/off those vexed "noise".
> >(It seems that 'q|quiet' doesn't do as much as what it hints.)
> 
> Make checkpatch.pl a C language parser, then it can handle
> all the whitespace violations without false positives. :-)

Well, yes, that's the root problem.
checkpatch is a regex tool, not a C parser.

And like Andy commented in another mail in this thread, (esp. since
it's not a C parser), it's just a guide.

---
~Randy
