Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYCKCQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYCKCQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYCKCQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:16:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbYCKCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:16:15 -0400
Date: Mon, 10 Mar 2008 19:15:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
In-Reply-To: <47D5D4E7.1060900@garzik.org>
Message-ID: <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
References: <200803110014.52985.rjw@sisk.pl> <47D5D4E7.1060900@garzik.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Mar 2008, Jeff Garzik wrote:
>
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> > Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3)
> > kernels
> > Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Date		:  Tue May 22 22:47:54 2007 -0400
> > References	: http://lkml.org/lkml/2008/3/10/340
> > Handled-By	: Gautham R Shenoy <ego@in.ibm.com>
> > Patch		: http://lkml.org/lkml/2008/3/10/91
> 
> FWIW, I have this same problem.

There's a newer patch in

	http://lkml.org/lkml/2008/3/10/343

which I think should replace the 2008/3/10/91 one, but which needs 
testing.

Jeff, does that one ("keep rd->online and cpu_online_map in sync") fix the 
problem for you?

(Andrew - I saw you say that the older patch fixed things for you, does 
the newer one - on its own - also do so?)

		Linus
