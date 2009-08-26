Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZHZFdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZHZFdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbZHZFdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:33:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:57804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbZHZFdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:33:00 -0400
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, raz ben yehuda <raziebe@gmail.com>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <4A943A00.9080609@nortel.com>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
	 <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 07:31:40 +0200
Message-Id: <1251264700.7538.1178.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 13:22 -0600, Chris Friesen wrote:
> On 08/25/2009 01:08 PM, Peter Zijlstra wrote:
> 
> > Christoph, stop being silly, this offline scheduler thing won't happen,
> > full stop.
> > 
> > Its not a maintainable solution, it doesn't integrate with existing
> > kernel infrastructure, and its plain ugly.
> > 
> > If you want something work within Linux, don't build kernels in kernels
> > or other such ugly hacks.
> 
> Is it the whole concept of isolating one or more cpus from all normal
> kernel tasks that you don't like, or just this particular implementation?
> 
> I ask because I know of at least one project that would have used this
> capability had it been available.  As it stands they have to live with
> the usual kernel threads running on the cpu that they're trying to
> dedicate to their app.

Its the simple fact of going around the kernel instead of using the
kernel.

Going around the kernel doesn't benefit anybody, least of all Linux.

So its the concept of running stuff on a CPU outside of Linux that I
don't like. I mean, if you want that, go ahead and run RTLinux, RTAI,
L4-Linux etc.. lots of special non-Linux hypervisor/exo-kernel like
things around for you to run things outside Linux with.
