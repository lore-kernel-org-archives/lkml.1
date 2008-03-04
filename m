Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYCDOAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYCDOAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYCDOAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:00:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37344 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbYCDOAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:00:04 -0500
Date: Tue, 4 Mar 2008 14:59:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080304135932.GF32383@elte.hu>
References: <200803030316.07165.rjw@sisk.pl> <20080304111715.GB23227@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304111715.GB23227@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10012
> > Subject		: 2.6.24-git4+ regression
> 
> Better  description would be "interactivity problems in -git4+".
> 
> > Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> > Date		: 2008-01-30 14:56
> > References	: http://lkml.org/lkml/2008/1/30/254
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > 		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> And he has GROUP_SCHED enabled, that is known broken. 

this should all be fixed in sched-devel.git (via a revert):

  http://people.redhat.com/mingo/sched-devel.git/README

it's lined up for upstream pull.

	Ingo
