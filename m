Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZCNKCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZCNKCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 06:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZCNKCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 06:02:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39939 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZCNKCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 06:02:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Sat, 14 Mar 2009 11:01:46 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903132256.51522.rjw@sisk.pl> <alpine.LFD.2.00.0903140829500.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903140829500.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141101.47961.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Thomas Gleixner wrote:
> On Fri, 13 Mar 2009, Rafael J. Wysocki wrote:
> > > > +		spin_unlock_irqrestore(&desc->lock, flags);
> > > 
> > > Ditto
> > 
> > No, because of __setup_irq().
> 
> Sorry, forgot about that. Ok. Keep the locking in pm.c then.

Will do, thanks.

OK, it seems we're approaching the final version. :-)

I'm going to split the $subject patch as requested by Ingo (API changes and
functionality changes) and post the full series once again for completness.

Thanks,
Rafael
