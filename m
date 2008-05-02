Return-Path: <linux-kernel-owner+w=401wt.eu-S935621AbYEBPtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935621AbYEBPtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763498AbYEBPtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:49:12 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:11767 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255AbYEBPtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:49:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Horrendous Audio Stutter - current git
Date: Fri, 2 May 2008 17:49:09 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <1209731822.25271.4.camel@marge.simson.net> <1209740523.4776.1.camel@marge.simson.net>
In-Reply-To: <1209740523.4776.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021749.10205.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 15:49:10.0773 (UTC) FILETIME=[102A9250:01C8AC6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Mike Galbraith wrote:
> On Fri, 2008-05-02 at 14:37 +0200, Mike Galbraith wrote:
> > On Fri, 2008-05-02 at 08:21 -0400, Parag Warudkar wrote:
> > > On Fri, May 2, 2008 at 8:09 AM, Mike Galbraith <efault@gmx.de> wrote:
> > > >  Hm.  I've stumbled across a regression that may be related.  Can
> > > > you please try the attached with group scheduling enabled in
> > > > current git?
> > >
> > > In file included from kernel/sched.c:1902:
> > > kernel/sched_fair.c: In function 'print_cfs_rq_tasks':
> > > kernel/sched_fair.c:1602: error: implicit declaration of function
> > > 'calc_delta_weight'
> > > kernel/sched_fair.c:1603: warning: format '%lu' expects type 'long
> > > unsigned int', but argument 5 has type 'int'
> > > make[1]: *** [kernel/sched.o] Error 1
> > > make: *** [kernel] Error 2
> > >
> > > 'calc_delta_weight' or a replacement not found easily to fix it up!
> >
> > Oops, I have an unrelated patch in my tree which you also need.
>
> I see that Peter has a fix, so don't bother.

Maybe not. It looks like Parag may have been seeing a combination of two 
different issues: the one that Peter fixed and one related to group 
scheduling.

As I had group scheduling disabled, I only saw the first one. But my audio 
skips were a lot less severe than Parag described. And disabling group 
scheduling helped solve the problem for him.

So it may well still be worth following up on this.

Cheers,
FJP
