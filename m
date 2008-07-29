Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYG2OyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYG2OyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYG2Ox6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:53:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54628 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYG2Ox5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:53:57 -0400
Date: Tue, 29 Jul 2008 16:53:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000002
Message-ID: <20080729145348.GN30344@one.firstfloor.org>
References: <20080725095317.GA12636@skywalker> <20080728222643.GA6339@slug> <1217305335.5553.3.camel@marge.simson.net> <20080729120911.GI30344@one.firstfloor.org> <20080729065635.27630e33@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729065635.27630e33@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 06:56:35AM -0700, Arjan van de Ven wrote:
> On Tue, 29 Jul 2008 14:09:11 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Tue, Jul 29, 2008 at 06:22:15AM +0200, Mike Galbraith wrote:
> > > On Tue, 2008-07-29 at 00:26 +0200, Frederik Deweerdt wrote:
> > > > Hello  Aneesh,
> > > > 
> > > > On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> > > > > [  163.378265] BUG: unable to handle kernel NULL pointer
> > > > > dereference at 00000002 [  163.378276] IP: [<c0124933>]
> > > > > sched_power_savings_store+0x13/0x70
> > > > 
> > > > Does the attached patch solve the problem?
> > > 
> > > Patch seems to have missed the boat for rc1 too.
> > 
> > Hmm.  I'll resend. 
> > 
> > BTW i think it's clearly a  bug that distributions are even accessing
> > that file. It doesn't make any sense in the context they are using
> > it (like at every boot). 
> 
> it's a power saving feature that they very likely turn on by default...

A power saving feature that has a significant trade off between power
and performance. 

This means performance will go down. Perhaps it would be ok on  battery,
but it's a feature that only makes sense on servers which don't have batteries.
So enabling it by default in a standard installation seems quite wrong 
to me.

BTW opensuse seems to even set it to 2 which doesn't even exist. This means
there was a BOF at OLS discussing adding more modes, but right now there is 
only 0 or 1.

-Andi
