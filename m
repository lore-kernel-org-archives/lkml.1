Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYG2MJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYG2MJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYG2MJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:09:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57345 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYG2MJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:09:17 -0400
Date: Tue, 29 Jul 2008 14:09:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000002
Message-ID: <20080729120911.GI30344@one.firstfloor.org>
References: <20080725095317.GA12636@skywalker> <20080728222643.GA6339@slug> <1217305335.5553.3.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217305335.5553.3.camel@marge.simson.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 06:22:15AM +0200, Mike Galbraith wrote:
> On Tue, 2008-07-29 at 00:26 +0200, Frederik Deweerdt wrote:
> > Hello  Aneesh,
> > 
> > On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> > > [  163.378265] BUG: unable to handle kernel NULL pointer dereference at 00000002
> > > [  163.378276] IP: [<c0124933>] sched_power_savings_store+0x13/0x70
> > 
> > Does the attached patch solve the problem?
> 
> Patch seems to have missed the boat for rc1 too.

Hmm.  I'll resend. 

BTW i think it's clearly a  bug that distributions are even accessing
that file. It doesn't make any sense in the context they are using
it (like at every boot). 

-Andi

