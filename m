Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYCKDBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYCKDBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 23:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYCKDBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 23:01:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbYCKDBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 23:01:03 -0400
Date: Mon, 10 Mar 2008 20:00:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Message-Id: <20080310200021.ef5b186e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
References: <200803110014.52985.rjw@sisk.pl>
	<47D5D4E7.1060900@garzik.org>
	<alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 19:15:45 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 10 Mar 2008, Jeff Garzik wrote:
> >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> > > Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3)
> > > kernels
> > > Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Date		:  Tue May 22 22:47:54 2007 -0400
> > > References	: http://lkml.org/lkml/2008/3/10/340
> > > Handled-By	: Gautham R Shenoy <ego@in.ibm.com>
> > > Patch		: http://lkml.org/lkml/2008/3/10/91
> > 
> > FWIW, I have this same problem.
> 
> There's a newer patch in
> 
> 	http://lkml.org/lkml/2008/3/10/343
> 
> which I think should replace the 2008/3/10/91 one, but which needs 
> testing.
> 
> Jeff, does that one ("keep rd->online and cpu_online_map in sync") fix the 
> problem for you?
> 
> (Andrew - I saw you say that the older patch fixed things for you, does 
> the newer one - on its own - also do so?)
> 

Yes, it does.
