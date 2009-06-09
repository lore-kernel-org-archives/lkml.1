Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZFIXxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZFIXxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZFIXxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:53:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbZFIXxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:53:41 -0400
Date: Tue, 9 Jun 2009 16:53:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: hpa@zytor.com, renton@renton.name, linux-kernel@vger.kernel.org
Subject: Re: devpts mounts too slowly
Message-Id: <20090609165304.add1a872.akpm@linux-foundation.org>
In-Reply-To: <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com>
References: <20090603142801.GC21646@beaver.vrungel.ru>
	<4A26EB18.6060907@zytor.com>
	<20090609161945.811cc01f.akpm@linux-foundation.org>
	<2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 16:30:31 -0700
Ray Lee <ray-lk@madrabbit.org> wrote:

> On Tue, Jun 9, 2009 at 4:19 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > On Wed, 03 Jun 2009 14:28:56 -0700
> > "H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> >> Alexey Vlasov wrote:
> >> > Hi.
> >> >
> >> > In comparison with bind/proc mounting it takes a lot more time mounting
> >> > devpts. Is it possible to somehow accelerate the process? Now there are
> >> > about 5k devpts mounting, it already took 20 minutes, further will take
> >> > even more time.
> >> >
> >> > # time mount -n -i -t devpts none /home/staff/.server-1/dev/pts
> >> > real __ __0m0.295s
> >> > user __ __0m0.000s
> >> > sys __ __ 0m0.288s
> >> >
> >>
> >> A profile would be handy here. __There is no sensible reason for this to
> >> that 0.3 seconds. __This might be RCU-epoch related?
> >>
> >
> > It seems OK here.
> >
> > akpm2:/home/akpm/xx# time mount -n -i -t devpts none /tmp/pts
> > mount -n -i -t devpts none /tmp/pts __0.00s user 0.00s system 0% cpu 0.002 total
> 
> I read the Original Post as that test being performed with 5k /dev/pts
> already mounted.

hm, OK.

I've now mounted 15000 devpts's and still no slowdown is evident.
