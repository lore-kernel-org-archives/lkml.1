Return-Path: <linux-kernel-owner+w=401wt.eu-S1423015AbXDTAAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423015AbXDTAAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 20:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423014AbXDTAAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 20:00:07 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:35723 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161303AbXDTAAE (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 19 Apr 2007 20:00:04 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2007 20:00:04 EDT
From: Jan Knutar <jk-lkml@sci.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Fri, 20 Apr 2007 02:52:38 +0300
User-Agent: KMail/1.6.2
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu>
In-Reply-To: <20070419151803.GB30959@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704200252.39459.jk-lkml@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 18:18, Ingo Molnar wrote:
> * Willy Tarreau <w@1wt.eu> wrote:
> > You can certainly script it with -geometry. But it is the wrong
> > application for this matter, because you benchmark X more than
> > glxgears itself. What would be better is something like a line
> > rotating 360 degrees and doing some short stuff between each
> > degree, so that X is not much sollicitated, but the CPU would be
> > spent more on the processes themselves.
>
> at least on my setup glxgears goes via DRI/DRM so there's no X
> scheduling inbetween at all, and the visual appearance of glxgears is
> a direct function of its scheduling.

How much of the subjective interactiveness-feel of the desktop is at the 
mercy of the X server's scheduling and not the cpu scheduler?

I've noticed that video playback is significantly smoother and resistant 
to other load, when using MPlayer's opengl output, especially if 
"heavy" programs are running at the same time. Especially firefox and 
ksysguard seem to have found a way to cause video through Xv to look 
annoyingly jittery.
