Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbYFDTiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbYFDTiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759695AbYFDTh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:37:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45158 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758602AbYFDTh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:37:57 -0400
Date: Wed, 4 Jun 2008 14:37:43 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: andi@firstfloor.org, ioe-lkml@rameria.de, sivanich@sgi.com,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
Message-Id: <20080604143743.b492c411.pj@sgi.com>
In-Reply-To: <4846ED88.6040100@qualcomm.com>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<48447C75.8040203@qualcomm.com>
	<200806030156.00155.ioe-lkml@rameria.de>
	<4844BB41.7000605@qualcomm.com>
	<4845D825.6000403@qualcomm.com>
	<20080603194148.56dfebe1.pj@sgi.com>
	<48461ADA.8020303@qualcomm.com>
	<877id5v1fg.fsf@basil.nowhere.org>
	<20080604124126.0d281a99.pj@sgi.com>
	<4846DF25.4020300@qualcomm.com>
	<20080604135826.f50f913a.pj@sgi.com>
	<4846ED88.6040100@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> btw Are you guys using some kind of castrated, statically linked shell to run
> that script ?

It (that init= program) is not a script.  It is its own
castrated, statically linked special purpose binary.
Once it has done its duty setting up cpusets, it then
exec's the normal init, confined to the cpuset configured
for it.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
