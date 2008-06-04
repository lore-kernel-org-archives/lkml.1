Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbYFDS6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbYFDS6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYFDS6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:58:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40114 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753101AbYFDS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:58:36 -0400
Date: Wed, 4 Jun 2008 13:58:26 -0500
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
Message-Id: <20080604135826.f50f913a.pj@sgi.com>
In-Reply-To: <4846DF25.4020300@qualcomm.com>
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
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> You do not even need to replace /sbin/init for this, no ?
> Simply installing custom
>	/etc/init.d/create_cpusets

That can ensure that the deamons that init starts later
on placed, but it doesn't ensure that the glibc pages that
init (and the shell it spawned to run 'create_cpusets')
are placed.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
