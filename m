Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbYFDTyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbYFDTyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762188AbYFDTyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:54:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35430 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762167AbYFDTyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:54:24 -0400
Date: Wed, 4 Jun 2008 22:03:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Paul Jackson <pj@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, maxk@qualcomm.com, ioe-lkml@rameria.de,
       sivanich@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Message-ID: <20080604200350.GL20824@one.firstfloor.org>
References: <20080601213019.14ea8ef8.pj@sgi.com> <1212446707.6269.26.camel@lappy.programming.kicks-ass.net> <48447C75.8040203@qualcomm.com> <200806030156.00155.ioe-lkml@rameria.de> <4844BB41.7000605@qualcomm.com> <4845D825.6000403@qualcomm.com> <20080603194148.56dfebe1.pj@sgi.com> <48461ADA.8020303@qualcomm.com> <877id5v1fg.fsf@basil.nowhere.org> <20080604124126.0d281a99.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604124126.0d281a99.pj@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We (SGI) routinely handle that need with a custom init program,
> invoked with the init= parameter to the booting kernel, which
> sets up cpusets and then invokes the normal (real) init program
> in a cpuset configured to exclude those CPUs and nodes which we
> want to remain unloaded.  For example, on a 256 CPU, 64 node
> system, we might have init running on a single node of 4 CPUs,
> and leave the remaining 63 nodes and 252 CPUs isolated from all
> the usual user level daemons started by init.
> 
> There is no need for additional kernel changes to accomplish this.

There are no additional changes needed, but you must admit that isolcpus
is a much more elegant solutation for this problem than hijacking init.

-Andi
