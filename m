Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYG2N5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYG2N5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbYG2N4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:56:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:37264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbYG2N4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:56:50 -0400
Date: Tue, 29 Jul 2008 06:56:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mike Galbraith <efault@gmx.de>, Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000002
Message-ID: <20080729065635.27630e33@infradead.org>
In-Reply-To: <20080729120911.GI30344@one.firstfloor.org>
References: <20080725095317.GA12636@skywalker>
	<20080728222643.GA6339@slug>
	<1217305335.5553.3.camel@marge.simson.net>
	<20080729120911.GI30344@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 14:09:11 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Jul 29, 2008 at 06:22:15AM +0200, Mike Galbraith wrote:
> > On Tue, 2008-07-29 at 00:26 +0200, Frederik Deweerdt wrote:
> > > Hello  Aneesh,
> > > 
> > > On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> > > > [  163.378265] BUG: unable to handle kernel NULL pointer
> > > > dereference at 00000002 [  163.378276] IP: [<c0124933>]
> > > > sched_power_savings_store+0x13/0x70
> > > 
> > > Does the attached patch solve the problem?
> > 
> > Patch seems to have missed the boat for rc1 too.
> 
> Hmm.  I'll resend. 
> 
> BTW i think it's clearly a  bug that distributions are even accessing
> that file. It doesn't make any sense in the context they are using
> it (like at every boot). 

it's a power saving feature that they very likely turn on by default...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
