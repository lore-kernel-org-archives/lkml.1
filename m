Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbXFDSms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbXFDSms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbXFDSmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:42:40 -0400
Received: from waste.org ([66.93.16.53]:59537 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbXFDSmj (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:42:39 -0400
Date: Mon, 4 Jun 2007 13:42:24 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604184224.GH11115@waste.org>
References: <20070604173710.GR11166@waste.org> <20070604181151.GA1745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604181151.GA1745@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 08:11:51PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > With 2.6.22-rc3-mm1, I've got a long-running video transcoding going 
> > on. In other windows, I'm compiling, reading email, etc. with no 
> > noticeable problems.
> > 
> > If I fire up lguest and leave it sitting at a shell prompt for a 
> > couple moments, when I return to type something at the prompt, it can 
> > take 2-3 seconds for my input to echo. Once it starts responding, 
> > typing latency disappears. Suspend the other app and the latency 
> > disappears.
> 
> btw., does this only happen with lguest, or with other idle shells too?

Only noticed with lguest.
 
> perhaps lguest does something unusual when it idles? Does it fiddle 
> sched_clock() in any way?

In the host? That'd be weird.

-- 
Mathematics is the supreme nostalgia of our time.
