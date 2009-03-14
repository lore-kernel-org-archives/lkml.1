Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZCNHd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZCNHd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZCNHdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:33:46 -0400
Received: from www.tglx.de ([62.245.132.106]:40374 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbZCNHdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:33:45 -0400
Date: Sat, 14 Mar 2009 08:31:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <200903132256.51522.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0903140829500.29264@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl> <alpine.LFD.2.00.0903132052240.29264@localhost.localdomain> <200903132256.51522.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009, Rafael J. Wysocki wrote:
> > > +		spin_unlock_irqrestore(&desc->lock, flags);
> > 
> > Ditto
> 
> No, because of __setup_irq().

Sorry, forgot about that. Ok. Keep the locking in pm.c then.

Thanks,

	tglx


