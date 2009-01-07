Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZAGE7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZAGE7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZAGE7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:59:24 -0500
Received: from relais.videotron.ca ([24.201.245.36]:36695 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZAGE7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:59:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 06 Jan 2009 23:59:16 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: powerpc: introduce asm/swab.h
In-reply-to: <1231303722.14442.1.camel@brick>
Message-id: <alpine.LFD.2.00.0901062354030.26118@xanadu.home>
References: <200901070400.n0740Ore002063@hera.kernel.org>
 <1231303340.14860.61.camel@pasglop> <1231303722.14442.1.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, Harvey Harrison wrote:

> On Wed, 2009-01-07 at 15:42 +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2009-01-07 at 04:00 +0000, Linux Kernel Mailing List wrote:
> > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=156ca2bbf6503a02d7d6829886ce381d572de66e
> > > Commit:     156ca2bbf6503a02d7d6829886ce381d572de66e
> > > Parent:     8cdd3a9261e8efe36aeb6c708edb76d7e2b5d13f
> > > Author:     Harvey Harrison <harvey.harrison@gmail.com>
> > > AuthorDate: Tue Jan 6 14:56:23 2009 -0800
> > > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> > > CommitDate: Tue Jan 6 18:10:27 2009 -0800
> > > 
> > >     powerpc: introduce asm/swab.h
> > >     
> > >     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > Was this tested ? I see no arch maintainer signed-off here, it appears
> > to at least break ppc32, and contains hunks that paulus says were
> > explicitely nacked (removing of our ld_* macros) etc...
> > 
> > Linus, please revert.
> 
> Please look a bit closer, it's a pure movement of code out of byteorder.h into swab.h,
> no changes whatsoever.

Well, this series breaks ARM as well:

In file included from include/linux/byteorder/little_endian.h:12,
                 from arch/arm/include/asm/byteorder.h:23,
                 from include/linux/kernel.h:20,
                 from include/linux/sched.h:52,
                 from arch/arm/kernel/asm-offsets.c:13:
include/linux/swab.h: In function '__fswab64':
include/linux/swab.h:71: error: implicit declaration of function '___swab32'


Nicolas
