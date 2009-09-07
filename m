Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZIGPd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZIGPd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZIGPd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:33:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:49744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbZIGPd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:33:26 -0400
Date: Mon, 7 Sep 2009 08:36:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Markus Tornqvist <mjt@nysv.org>, Ingo Molnar <mingo@elte.hu>,
       kernel@kolivas.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and
 measurements
Message-ID: <20090907083642.5e2b575c@infradead.org>
In-Reply-To: <200909071720.36428.elendil@planet.nl>
References: <20090907121613.GA32097@elte.hu>
	<20090907131905.GP28624@nysv.org>
	<20090907074507.7f00a3ec@infradead.org>
	<200909071720.36428.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009 17:20:33 +0200
Frans Pop <elendil@planet.nl> wrote:

> On Monday 07 September 2009, Arjan van de Ven wrote:
> > 4 cores, 8 threads. Which is basically the standard desktop cpu
> > going forward... (4 cores already is today, 8 threads is that any
> > day now)
> 
> Despite that I'm personally more interested in what I have available
> here *now*. And that's various UP Pentium systems, one dual core
> Pentium D and Core Duo.
> 
> I've been running BFS on my laptop today while doing CPU intensive
> jobs (not disk intensive), and I must say that BFS does seem very
> responsive. OTOH, I've also noticed some surprising things, such as
> processors staying on lower frequencies while doing CPU-intensive
> work.
> 
> I feels like I have less of the mouse cursor and typing freezes I'm
> used to with CFS, even when I'm *not* doing anything special. I've
> been blaming those on still running with ordered mode ext3, but now
> I'm starting to wonder.
> 
> I'll try to do more structured testing, comparisons and measurements 
> later. At the very least it's nice to have something to compare
> _with_.
> 

it's a shameless plug since I wrote it, but latencytop will be able to
tell you what your bottleneck is...
and that is very interesting to know, regardless of the "what scheduler
code" discussion;

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
