Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbXJZFWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbXJZFWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXJZFWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:22:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbXJZFWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:22:00 -0400
Date: Thu, 25 Oct 2007 22:21:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Russ Dill" <russ.dill@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Better document profile=
Message-Id: <20071025222155.9534a6d7.akpm@linux-foundation.org>
In-Reply-To: <f9d2a5e10710252203n7ff40690j8d4822310826f9e8@mail.gmail.com>
References: <f9d2a5e10710162216s149c16a3j9bb63d60fdf1e782@mail.gmail.com>
	<20071025163743.7a3d8231.akpm@linux-foundation.org>
	<f9d2a5e10710252203n7ff40690j8d4822310826f9e8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 22:03:21 -0700 "Russ Dill" <russ.dill@gmail.com> wrote:

> > >                       Format: [schedule,]<number>
> > >                       Param: "schedule" - profile schedule points.
> > >                       Param: <number> - step/bucket size as a power of 2 for
> > > -                             statistical time based profiling.
> > > +                             statistical time based profiling. A value of
> > > +                             2 will provide a granularity of 4 bytes, a
> > > +                             value of 3 will provide a granularity of 8
> > > +                             bytes and so on.
> > >                       Param: "sleep" - profile D-state sleeping (millisecs)
> >
> > Actually the prof_shift isn't in units of bytes: it is in units of
> > sizeof(unsigned long).
> 
> 
> I thought we just went through this?

Just.  I seem to recall discussing this with someone a number of weeks ago.
Sorry, but my memory gets flushed a lot more frequently than that.

> extern char _text[], _stext[], _etext[];
> [...]
> prof_len = (_etext - _stext) >> prof_shift;
> prof_buffer = alloc_bootmem(prof_len*sizeof(atomic_t));
> 

ok, you're right.
