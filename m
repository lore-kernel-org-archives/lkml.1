Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXFDIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXFDIfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXFDIfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:35:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbXFDIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:35:36 -0400
Date: Mon, 4 Jun 2007 01:34:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070604013449.ea3acca8.akpm@linux-foundation.org>
In-Reply-To: <20070604080941.GA23537@elte.hu>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
	<20070603230859.5000424d.akpm@linux-foundation.org>
	<20070604080537.GA22898@elte.hu>
	<20070604080941.GA23537@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 10:09:41 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i think this sums it up:
> > 
> >  http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2490.html
> 
> i mean this mail started it:
> 
>   http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-05/msg13070.html
> 
> > and some more, with a benchmark as well:
> > 
> >  http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-05/msg13685.html
> 

Yeah, I remember all that but I don't think it provides a suitable
description of what all this code is there for - what problem it is
solving and how it solves it.

If we just want some pseudo-private fd space for glibc to use then I'd have
thought that the existing code could be tweaked to do that: top-down
allocation, start at some high offset, etc.  But apparently there's more
to it than this.


