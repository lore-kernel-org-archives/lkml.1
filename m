Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbZLPPCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbZLPPCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZLPPCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:02:10 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:47260 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbZLPPCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:02:09 -0500
Date: Wed, 16 Dec 2009 10:01:39 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Kyle McMartin <kyle@mcmartin.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: anyone including <linux/perf_counter.h>?
In-Reply-To: <20091216145851.GM28962@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.0912161000130.7970@localhost>
References: <alpine.LFD.2.00.0912160939510.7588@localhost> <20091216145120.GL28962@bombadil.infradead.org> <alpine.LFD.2.00.0912160955420.7853@localhost> <20091216145851.GM28962@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009, Kyle McMartin wrote:

> On Wed, Dec 16, 2009 at 09:56:47AM -0500, Robert P. J. Day wrote:
> > > See the comment at the top, it's being provided to provide the
> > > old names to userspace for a short time, now that the
> > > functionality has been renamed to perf_events.
> >
> >   but if it's supposed to be providing info to user-space,
> > shouldn't it be *exported* to user space?  it's not listed in
> > include/linux/Kbuild.  or am i misunderstanding?
>
> No, you're quite correct, my guess would be that the original
> perf_counter.h header-y line was renamed to perf_event.h, and
> someone forgot to add a new one for the old header.

  so i can submit a patch to do one of two things:

  1) add it into Kbuild, since user-space needs it, or

  2) delete it entirely since it's never been in user-space all
     this time but no one seems to have missed it.  :-)

  thoughts?  i'm fine either way.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
