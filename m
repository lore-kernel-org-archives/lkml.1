Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbYFDUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbYFDUXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYFDUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:23:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54308 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624AbYFDUXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:23:24 -0400
Date: Wed, 4 Jun 2008 15:23:17 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: maxk@qualcomm.com, andi@firstfloor.org, ioe-lkml@rameria.de,
       sivanich@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
Message-Id: <20080604152317.5a36d2cc.pj@sgi.com>
In-Reply-To: <20080604200508.GM20824@one.firstfloor.org>
References: <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<48447C75.8040203@qualcomm.com>
	<200806030156.00155.ioe-lkml@rameria.de>
	<4844BB41.7000605@qualcomm.com>
	<4845D825.6000403@qualcomm.com>
	<20080603194148.56dfebe1.pj@sgi.com>
	<48461ADA.8020303@qualcomm.com>
	<877id5v1fg.fsf@basil.nowhere.org>
	<20080604124126.0d281a99.pj@sgi.com>
	<4846DF25.4020300@qualcomm.com>
	<20080604200508.GM20824@one.firstfloor.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, replying to Max:
> > That script will move init itself into the appropriate cpuset and from then on
> > everything will inherit it.
> 
> It won't be the parent of the other init scripts.

True, but init will be the parent of other init scripts,
and init itself was moved into the appropriate cpuset.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
