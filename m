Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZDPXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZDPXIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZDPXIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:08:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbZDPXII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:08:08 -0400
Date: Fri, 17 Apr 2009 01:07:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Peter Oruba <peter.oruba@amd.com>,
       amd64-microcode@amd64.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode driver newly spews warnings
Message-ID: <20090416230731.GA19553@elte.hu>
References: <49E38331.3090808@garzik.org> <49E38393.8000700@garzik.org> <20090413182746.GA9954@elte.hu> <49E5EABB.9010402@garzik.org> <b647ffbd0904150751u64e69097q79c511533f949c00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0904150751u64e69097q79c511533f949c00@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> 2009/4/15 Jeff Garzik <jeff@garzik.org>:
> > Ingo Molnar wrote:
> >>
> >> (added Cc:s)
> >>
> >> * Jeff Garzik <jeff@garzik.org> wrote:
> >>
> >>> Jeff Garzik wrote:
> >>>>
> >>>> Kernel: 2.6.30-rc1-00306-g8371f87
> >>>> Hardware: ICH10 x86-64
> >>>>
> >>>> This is a regression from 2.6.29.  Microcode spews the following WARNING
> >>>> multiple times during boot:
> >>>>
> >>>>> ------------[ cut here ]------------
> >>>>> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
> >>>>> Hardware name:         sysfs group ffffffffa0209700 not found for
> >>>>>  kobject 'cpu0'
> >
> >
> > Update:  Regression occurs in 2.6.30-rc2.
> >
> > I've now reproduced this on ICH9/Core2 as well as ICH10/Nahelem.
> 
> Hi,
> 
> 
> the following patch should eliminate the problem (and revert to 
> the old behavior that was altered by Rusty's patch).

Jeff, did this do the trick for you?

	Ingo
