Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXDVEeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXDVEeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 00:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXDVEeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 00:34:37 -0400
Received: from [212.12.190.61] ([212.12.190.61]:32844 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754056AbXDVEeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 00:34:36 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sun, 22 Apr 2007 07:38:27 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704220738.27348.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Sunday 22 April 2007 02:00, Ingo Molnar wrote:
> > * Con Kolivas <kernel@kolivas.org> wrote:
> > > >   Feels even better, mouse movements are very smooth even under high
> > > >   load. I noticed that X gets reniced to -19 with this scheduler.
> > > >   I've not looked at the code yet but this looked suspicious to me.
> > > >   I've reniced it to 0 and it did not change any behaviour. Still
> > > >   very good.
> > >
> > > Looks like this code does it:
> > >
> > > +int sysctl_sched_privileged_nice_level __read_mostly = -19;
> >
> > correct.
>
> Oh I definitely was not advocating against renicing X, I just suspect that
> virtually all the users who gave glowing reports to CFS comparing it to SD
> had no idea it had reniced X to -19 behind their back and that they were
> comparing it to SD running X at nice 0. I think had they been comparing
> CFS with X nice -19 to SD running nice -10 in this interactivity soft and
> squishy comparison land their thoughts might have been different. I missed
> it in the announcement and had to go looking in the code since Willy just
> kinda tripped over it unwittingly as well.

I tried this with the vesa driver of X, and reflect from the mesa-demos 
heavily starves new window creation on cfs-v4 with X niced -19.  X reniced 
to 0 removes these starves.  On SD, X reniced to -10 works great.


Thanks!

--
Al

