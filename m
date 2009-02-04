Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbZBDVdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbZBDVdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZBDVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:32:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbZBDVcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:32:15 -0500
Date: Wed, 4 Feb 2009 22:32:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
Message-ID: <20090204213202.GP22608@elte.hu>
References: <200901301729.30284.borntraeger@de.ibm.com> <200902030948.13519.borntraeger@de.ibm.com> <20090203122847.GG19979@elte.hu> <200902040719.25593.borntraeger@de.ibm.com> <1233777584.16238.16.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233777584.16238.16.camel@vayu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Tue, 2009-02-03 at 22:19 -0800, Christian Borntraeger wrote:
> > Am Tuesday 03 February 2009 13:28:47 schrieb Ingo Molnar:
> > > > > +         if (!cpu_active(cpu) {
> > > >
> > > > That does not compile...I used the following:
> > > >             if (!cpu_active(cpu)) {
> > >
> > > Could you please resubmit an updated patch?
> > 
> > Suresh,
> > 
> > can you send the updated patch? After all, its your work and we need your
> > Signed-off-by anyway.
> > 
> > You can add my
> > Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Thanks Christian for testing the fix. Ingo, appended is the updated patch. 
> Thanks.

applied to tip:sched/urgent, thanks guys!

	Ingo
