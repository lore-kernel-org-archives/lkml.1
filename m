Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZHYTSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZHYTSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZHYTSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:18:42 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:39429 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755927AbZHYTSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:18:41 -0400
Date: Tue, 25 Aug 2009 15:18:13 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Mike Galbraith <efault@gmx.de>, raz ben yehuda <raziebe@gmail.com>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <1251227322.7538.1172.camel@twins>
Message-ID: <alpine.DEB.1.10.0908251515550.17963@gentwo.org>
References: <1250983671.5688.21.camel@raz>  <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>  <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>  <1251021133.14003.172.camel@marge.simson.net> 
 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>  <1251222993.7023.53.camel@marge.simson.net>  <alpine.DEB.1.10.0908251402300.17963@gentwo.org> <1251227322.7538.1172.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Peter Zijlstra wrote:

> On Tue, 2009-08-25 at 14:03 -0400, Christoph Lameter wrote:
> > On Tue, 25 Aug 2009, Mike Galbraith wrote:
> >
> > > I asked the questions I did out of pure curiosity, and that curiosity
> > > has been satisfied.  It's not that I find it useless or whatnot (or that
> > > my opinion matters to anyone but me;).  I personally find the concept of
> > > injecting an RTOS into a general purpose OS with no isolation to be
> > > alien.  Intriguing, but very very alien.
> >
> > Well lets work on the isolation piece then. We could run a regular process
> > on the RT cpu and switch back when OS services are needed?
>
> Christoph, stop being silly, this offline scheduler thing won't happen,
> full stop.

Well there are the low latency requirements still. Those need to be
addressed in some form. Some of these ideas here are a starting point.

> Its not a maintainable solution, it doesn't integrate with existing
> kernel infrastructure, and its plain ugly.
>
> If you want something work within Linux, don't build kernels in kernels
> or other such ugly hacks.

Ok so how would you go about avoiding the OS noise which motivated
the patches for the Offline scheduler?

