Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYACOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYACOhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYACOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:37:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36620 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYACOh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:37:29 -0500
Date: Thu, 3 Jan 2008 15:37:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
Message-ID: <20080103143711.GA29606@elte.hu>
References: <20080103111925.GC8046@cvg> <20080103112957.GA14693@lazybastard.org> <20080103140549.GA19363@elte.hu> <1199370550.3697.79.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199370550.3697.79.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2008-01-03 at 15:05 +0100, Ingo Molnar wrote:
> > not to make a big issue out of this, but when was the last time you 
> > tried to grep this way:
> > 
> >   grep -E "audit_rate_limit=[0-9]+ audit_backlog" */*.c
> 
> Not precisely that, but I've certainly had greps fail because people 
> have split up strings to meet the stupid 80-character "limit".

yes - but if you read my whole reply you'll see that i qualified it:

>> That's pretty much the only grep pattern that would break. People 
>> usually grep on the constant portion of the string, so breaking up a 
>>                                                       ^^^^^^^^^^^^^
>> line along a variable boundary is perfectly okay.
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	Ingo
