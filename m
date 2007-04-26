Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXDZCxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXDZCxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 22:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbXDZCxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 22:53:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbXDZCxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 22:53:37 -0400
Date: Wed, 25 Apr 2007 19:53:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Nonfunctional ethernet (was Re: 2.6.21-rc7-mm1 +
 sysfs-oops-workaround.patch -- INFO: possible recursive locking detected)
Message-Id: <20070425195326.dba3ab2d.akpm@linux-foundation.org>
In-Reply-To: <46300DDC.1070805@gmail.com>
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
	<462EE4B7.6000708@gmail.com>
	<1177512528.4856.15.camel@daplas>
	<1177544702.4668.9.camel@daplas>
	<1177549323.4685.3.camel@daplas>
	<20070425181302.ebae7481.akpm@linux-foundation.org>
	<46300DDC.1070805@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 11:26:36 +0900 Tejun Heo <htejun@gmail.com> wrote:

> Hello, Antonino, Andrew.
> 
> Andrew Morton wrote:
> > On Thu, 26 Apr 2007 09:02:02 +0800 "Antonino A. Daplas" <adaplas@gmail.com> wrote:
> > 
> >> I can bring up the network manually using ifconfig.  It's opensuse's
> >> rcnetwork script that fails to bring the network up. Entries
> >> in /sys/class/net are still bogus.
> >>
> >> This kernel is now usable to me, I'll start bisection later today if
> >> nobody has an answer.
> > 
> > rc7-mm1 is hardly worth bothering with.  Quite a few really bad ones have
> > now been fixed and I'll try to get rc7-mm2 out within the next 12 hours (I
> > assume a 76-hour debug session won't be needed this time).
> > 
> > But I don't think the sysfs changes in Greg's tree have been updated, so
> > things will probably still fail in that area.  A suitable bisection
> > starting pair would be around gregkh-driver-*
> 
> This is the rename bug I wrote about in the other thread.

ok.

>  Can you hold -mm2 off a bit?  I'm almost done here.

sure.  I'm having much fun with all the obviously-wont-compile patches
which have been checked into various subsystem trees in the past 24 hours.

Please include simple instructions about which gregkh patches I should drop
when this new set comes in.
