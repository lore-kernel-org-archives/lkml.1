Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbXH0MMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbXH0MMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbXH0MLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:11:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbXH0MLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:11:46 -0400
Date: Mon, 27 Aug 2007 14:11:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthias Hensler <matthias@wspse.de>, Christian Hesse <mail@earthworm.de>,
       suspend2-devel@lists.tuxonice.net, Suspend2-users@lists.suspend2.net,
       linux-kernel@vger.kernel.org,
       suspend2-devel <suspend2-devel@lists.suspend2.net>,
       David Rodriguez <livuxman@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend2-devel] Problem with CFS V20 and Suspend2/tuxonice
Message-ID: <20070827121130.GA27592@elte.hu>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com> <b637ec0b0708250554m35decdb3ic8db88787fc3c0c9@mail.gmail.com> <200708251852.28698.mail@earthworm.de> <20070825184917.GA7945@kobayashi-maru.wspse.de> <20070825190223.GC15888@elte.hu> <20070827114120.GA1797@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827114120.GA1797@elf.ucw.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > > Me too for 2.6.22.5, TuxOnIce 2.2.10 and Centrino based notebook.

> > +		try_to_freeze();
> > +
> >  		spin_lock_irq(&rq->lock);
> >  
> >  		if (cpu_is_offline(cpu)) {
> 
> If it is NONFREEZE, you should not be trying to freeze it.

that fix is for .22 - the bug is a backporting bug. (i look .23's 
sched.c and stuck it into .22)

	Ingo
