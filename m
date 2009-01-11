Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZAKQgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZAKQgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZAKQg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:36:27 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:43087 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZAKQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:36:26 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Date: Sun, 11 Jan 2009 17:36:24 +0100
User-Agent: KMail/1.9.9
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Daniel Drake <dsd@gentoo.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Phil Dibowitz <phil@ipom.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com> <20090111162949.GA15338@elte.hu>
In-Reply-To: <20090111162949.GA15338@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111736.24350.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 11 Januar 2009 schrieb Ingo Molnar:
> 
> * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> 
> > On Sun, Jan 11, 2009 at 10:18 PM, Christian Borntraeger
> > <borntraeger@de.ibm.com> wrote:
> > > Am Sonntag 11 Januar 2009 schrieb Daniel Drake:
> > >> Rafael J. Wysocki wrote:
> > >> > This message has been generated automatically as a part of a report
> > >> > of recent regressions.
> > >> >
> > >> > The following bug entry is on the current list of known regressions
> > >> > from 2.6.28.  Please verify if it still should be listed and let me 
know
> > >> > (either way).
> > >> >
> > >> >
> > >> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=12422
> > >> > Subject             : 2.6.28-git can't resume from str
> > >> > Submitter   : Jeff Chua <jeff.chua.linux@gmail.com>
> > >> > Date                : 2009-01-10 1:39 (2 days old)
> > >> > References  : http://marc.info/?l=linux-kernel&m=123155157909282&w=4
> > >>
> > >> The bisection looks invalid. It is unlikely to be this commit at fault.
> > >> Jeff, do you even have that camera?
> > >>
> > >> It is also easy to revert that commit by hand. Just delete the
> > >> unusual_devs entry for it.
> > >
> > > I found a nearby commit during bisect, which looks much saner:
> > >
> > > http://marc.info/?l=linux-kernel&m=123167815028388&w=2
> > 
> > This was committed earlier than
> > a0e280e0f33f6c859a235fb69a875ed8f3420388, and
> > a0e280e0f33f6c859a235fb69a875ed8f3420388 was the last working kernel
> > that is able to suspend/resume. Go one before, and suspend/resume
> > breaks.
> 
> so you mean a0e280e0f33f6c859a235fb69a875ed8f3420388 seems good, while the 
> next step in Linus's tree, 52fefcec97c25b15887e6a9a885ca54e7f7c0928 is 
> already broken?

I guess Jeff, meant the other way around.
Since a0e280e0f33f6c859a235fb69a875ed8f3420388 is a fix for a known S2R 
problem , the earlier patch (before) does of course not work.

