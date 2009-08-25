Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZHYSMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZHYSMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZHYSMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:12:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:60818 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755501AbZHYSMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:12:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/rYUAGiMXrBSABPNJ88UIiXTCXorT6O/ABzAI7bA
	/X7fxLV8WXfn0P
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: raz ben yehuda <raziebe@gmail.com>, riel@redhat.com, mingo@elte.hu,
       peterz@infradead.org, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 20:12:50 +0200
Message-Id: <1251223970.7023.61.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 14:03 -0400, Christoph Lameter wrote:
> On Tue, 25 Aug 2009, Mike Galbraith wrote:
> 
> > I asked the questions I did out of pure curiosity, and that curiosity
> > has been satisfied.  It's not that I find it useless or whatnot (or that
> > my opinion matters to anyone but me;).  I personally find the concept of
> > injecting an RTOS into a general purpose OS with no isolation to be
> > alien.  Intriguing, but very very alien.
> 
> Well lets work on the isolation piece then. We could run a regular process
> on the RT cpu and switch back when OS services are needed?

If there were isolation, that would make it much less alien to _me_.
Isolation would kinda destroy the reason it was written though. RT
application/OS is injected into the network stack, which is kinda cool,
but makes the hairs on my neck stand up.

	-Mike

