Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbYDURA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbYDURA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYDURAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:00:50 -0400
Received: from mail.queued.net ([207.210.101.209]:3084 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbYDURAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:49 -0400
Date: Mon, 21 Apr 2008 13:03:20 -0400
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Mitch Bradley <wmb@firmworks.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
Message-ID: <20080421130320.38b5f505@ephemeral>
In-Reply-To: <1208793253.9212.507.camel@pmac.infradead.org>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
	<20080419133909.5aa6b63e@ephemeral>
	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	<480C0582.9010509@firmworks.com>
	<86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	<480C1286.3040307@firmworks.com>
	<20080421102417.6de71391@ephemeral>
	<1208793253.9212.507.camel@pmac.infradead.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 16:54:13 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2008-04-21 at 10:24 -0400, Andres Salomon wrote:
> > I'm not actually convinced that we *do* want to keep OFW resident in memory,
> > especially given the memory tricks we need to play.  I also don't actually
> > like the OFW interface that we.  The debugging aspect of it was a
> > compelling argument up until a week ago (when kernel debuggers started
> > finally finding their way into the kernel).
> 
> I don't actually think that the debugging aspect was _ever_ a compelling
> argument. It might have made it theoretically possible for _Mitch_ to
> debug kernel problems, should he be inclined to do so -- but for the
> rest of us mere mortals it's just a PITA trying to keep OpenFirmware
> live. A gdb stub is much more useful, in my experience.
> 
> > However, until we clean up the promfs stuff, there's no chance of getting
> > an OFW device tree upstream.
> 
> I see no reason why we shouldn't be able to create a 'flattened'b
> device-tree during early boot, like the PowerPC kernel does. And use it
> thereafter, having quiesced OpenFirmware. Haven't we already been
> working on unifying this between SPARC and PowerPC kernels?

Quite simply, it's a lot more work (*and* we have to play nice w/
sparc and ppc).  I had intended to eventually do it, but first I wanted
to get this stuff in for 2.6.26 so that we could at least boot upstream
kernels on XOs.

I was also hoping to not get into this conversation, but alas.. too
late. :)


> 
> I definitely don't think we need to play these tricks to keep
> OpenFirmware resident while the kernel is running. Take a look at your
> second patch -- it's _all_ just lookups in the device-tree, and you're
> inventing a new way to do it instead of using the existing one.
> 


-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
