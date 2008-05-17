Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbYEQUpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbYEQUpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbYEQUpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:45:30 -0400
Received: from 1wt.eu ([62.212.114.60]:4348 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647AbYEQUp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:45:28 -0400
Date: Sat, 17 May 2008 22:45:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: koos vriezen <koos.vriezen@gmail.com>, linux-kernel@vger.kernel.org,
       mchehab@infradead.org, torvalds@linux-foundation.org
Subject: Re: mplayer v4l hangs in 2.6.25.2/4 (likely regression)
Message-ID: <20080517204505.GX8474@1wt.eu>
References: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com> <20080517111639.21a3e177@infradead.org> <d4e708d60805171211q1a1966a3i78dc3dc98d275dd1@mail.gmail.com> <20080517122640.2d15aeed@infradead.org> <20080517123452.79b82be2@infradead.org> <d4e708d60805171306n698192aas66b42a9468253448@mail.gmail.com> <20080517132050.2dae0ddd@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080517132050.2dae0ddd@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 01:20:50PM -0700, Arjan van de Ven wrote:
> On Sat, 17 May 2008 22:06:12 +0200
> "koos vriezen" <koos.vriezen@gmail.com> wrote:
> 
> > 2008/5/17 Arjan van de Ven <arjan@infradead.org>:
> > 
> > > > so.. bttv first takes "fh->cap.vb_lock" in vidiocgmbuf, then
> > > > calls videobuf_mmap_setup(), and the first thing that does
> > is to also take fh->cap.vb_lock!  This isn't even an ABBA deadlock,
> > but a straight AA deadlock :)
> > 
> > Looks like I'm the only one actually running this code ;-)
> > 
> > > and here is an (untest) patch that should fix this problem:
> > > Koos, can you apply this to your kernel tree and report back if this
> > > fixes your deadlock?
> > 
> > patching file drivers/media/video/bt8xx/bttv-driver.c
> > patching file drivers/media/video/videobuf-core.c
> > Hunk #1 succeeded at 335 (offset 4 lines).
> > Hunk #2 succeeded at 1093 (offset -36 lines).
> > patching file include/media/videobuf-core.h
> > Hunk #1 succeeded at 227 (offset -10 lines).
> > 
> > Deadlock is gone, only mplayer fails to unmute the audio. 
> 
> that's something else entirely ;)
> 
> I'll call your deadlock bug fixed by the patch...
> 
> Mauro: will you send this on to Linus or should this go direct?

also please do not forget to CC stable.

Willy

