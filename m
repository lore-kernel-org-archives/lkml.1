Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYDJMqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYDJMqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYDJMqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:46:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56417 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbYDJMqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:46:07 -0400
Subject: Re: Western Digital GreenPower drives and Linux
From: Kasper Sandberg <lkml@metanurb.dk>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200804100848.08442.tvrtko@ursulin.net>
References: <200804092118.35501.tvrtko@ursulin.net>
	 <200804100848.08442.tvrtko@ursulin.net>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 14:44:41 +0200
Message-Id: <1207831481.1514.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-10 at 08:48 +0100, Tvrtko A. Ursulin wrote:
> On Wednesday 09 April 2008 21:18:35 Tvrtko A. Ursulin wrote:
> > I got one of them (WD5000AACS) recently and to my horror after less than
> > three days of being power on this is what I saw:
> >
> > 9 Power_On_Hours       0x0032 100 100 000 Old_age Always  - 66
> > 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
> >
> > At this rate the disk would reach it's design limit for load/unload cycles
> > in around 80 days. Not good - so I implemented a lame workaround of keeping
> > disk busy every couple of seconds - hopefully that won't kill it sooner
> > that unloads would..
> >
> > I am also currently talking with first line of WD's tech support trying to
> > get some data on how exactly those drives manage head unloading, but that
> > may not lead anywhere useful.
> 
> I got back from WD's tech support and received a DOS utility which can control 
> this drive feature, apparently using vendor specific commands. With it head 
> unload timer can be disabled or set to a period between 100ms and 25.5s. 
> 
> Of course I asked for more than a DOS utility, but the question really is how 
> was this feature intended to work with Windows for example, is there 
> something there which would prevent such rapid load/unload cycle growth, and 
>From my experience windows is expert at doing weird IO basically all the
time, perhaps this is why they never had this trouble when testing..
(which is kindof weird, as one would think lots of people would be
especially interrested in getting energy saving disks in their servers)

> why isn't it documented somewhere?
> 
> I am kind off hoping that someone from WD is reading this list and will notice 
> this in case my effort with tech support fails.
> 
> Tvrtko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

