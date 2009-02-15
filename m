Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZBOXNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZBOXNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 18:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZBOXNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 18:13:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48521 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbZBOXNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 18:13:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12263] Sata soft reset filling log
Date: Mon, 16 Feb 2009 00:12:56 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Justin Madru <jdm64@gawab.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu>
In-Reply-To: <20090215223045.GC29300@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902160012.57584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Sunday 15 February 2009, Justin Madru wrote:
> > > Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of regressions introduced between 2.6.27 and 2.6.28.
> > > >
> > > > The following bug entry is on the current list of known regressions
> > > > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > > > be listed and let me know (either way).
> > > >
> > > >
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12263
> > > > Subject		: Sata soft reset filling log
> > > > Submitter	: Justin Madru <bevicm@dslextreme.com>
> > > > Date		: 2008-12-13 2:07 (64 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=122913412608533&w=4
> > > 
> > > I'm still seeing this on .29-rc5, and I think that my bug #12263 is a 
> > > duplicate of bug #12609,
> > > or more correctly it's a duplicate of mine because I reported first.
> > > 
> > > It seems like the bug has been fixed in tip/master for some time now.
> > > Below is the diff of origin and tip from when I tested.
> > 
> > Ingo, do you know whinch patch in -tip fixes this regression?
> 
> This one, done on Jan 10, more than a month ago:
> 
>   f1d26da: Revert "libata: Add 32bit PIO support"
> 
> When a commit causes trouble in -tip qa i immediately revert it in 95% 
> of the cases, no questions asked. Especially if it's related to 
> persistent storage.

OK, thanks.

We seem to have a working fix patch for this issue in bug #12609.

Best,
Rafael
