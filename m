Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbYDKJIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbYDKJIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbYDKJHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:07:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966AbYDKJHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:07:54 -0400
Date: Fri, 11 Apr 2008 11:07:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Justin Mattock <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: mutex_unlock
Message-ID: <20080411090729.GD10801@elte.hu>
References: <dd18b0c30804090017m75c97f81qf6428b377432f8b5@mail.gmail.com> <200804092240.26623.rjw@sisk.pl> <dd18b0c30804091440x6e029daes8dd5f4dd848f5154@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30804091440x6e029daes8dd5f4dd848f5154@mail.gmail.com>
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


* Justin Mattock <justinmattock@gmail.com> wrote:

> >  > 2.6.25-rc8-00194-g4cac04d ran vary smoothly;
> >  > then I decided to pull the latest git (2.6.25-rc8-00208-g7180c4c)and
> >  > see what I might find.
> >  > upon reboot the system starts up giving me this:
> >  >
> >  > Starting up
> >  > Decompressing Linux Done
> >  > Booting the kernel
> >  > __   <-------blinking
> >  >
> >  > I waited a few seconds or minutes but nothing;

to perhaps get more kernel messages about this, try the earlyprintk=vga 
boot option - does it produce any messages?

	Ingo
