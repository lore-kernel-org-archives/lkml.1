Return-Path: <linux-kernel-owner+w=401wt.eu-S1764365AbYA1X2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764365AbYA1X2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbYA1X2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:28:14 -0500
Received: from main.gmane.org ([80.91.229.2]:35600 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYA1X2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:28:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: Kernel Event Notifications (was: [RFC] Parallelize IO for
	e2fsck)
Date: Mon, 28 Jan 2008 18:28:02 -0500
Organization: World Organi[sz]ation Of Broken Dreams
Message-ID: <1201562634.5412.70.camel@jcmlaptop>
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <20080124234037.GJ15858@mit.edu>
	 <2f11576a0801260432y4405d817p6ef4005d06189654@mail.gmail.com>
	 <200801261655.31313.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: nat-pool-bos.redhat.com
In-Reply-To: <200801261655.31313.a1426z@gawab.com>
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-26 at 16:55 +0300, Al Boldi wrote:
> KOSAKI Motohiro wrote:
> > > > And from a performance point of view letting applications voluntarily
> > > > free some memory is better even than starting to swap.
> > >
> > > Absolutely.
> >
> > the mem_notify patch can realize "just before starting swapping"
> > notification :)

I looked at this a year or two back, then ran out of time. But the thing
I wanted to do was have libc's memory allocation routines extended to
handle these through reservations - the kernel should send a userspace
notification and then there should be some kind of concept of returning
memory that's been used for "opportunistic" userspace caching, e.g. in
firefox to cache the last 10 web pages. Let us know how you get on :)

Jon.



