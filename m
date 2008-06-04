Return-Path: <linux-kernel-owner+w=401wt.eu-S1762430AbYFDTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430AbYFDTzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbYFDTzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:55:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505AbYFDTzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:55:39 -0400
Date: Wed, 4 Jun 2008 22:05:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       ioe-lkml@rameria.de, sivanich@sgi.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@kolivas.org, dfults@sgi.com,
       devik@cdi.cz, dino@in.ibm.com, emmanuel.pacaud@univ-poitiers.fr,
       deweerdt@free.fr, mingo@elte.hu, colpatch@us.ibm.com,
       nickpiggin@yahoo.com.au, rostedt@goodmis.org, oleg@tv-sign.ru,
       paulmck@us.ibm.com, menage@google.com, rddunlap@osdl.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Message-ID: <20080604200508.GM20824@one.firstfloor.org>
References: <1212446707.6269.26.camel@lappy.programming.kicks-ass.net> <48447C75.8040203@qualcomm.com> <200806030156.00155.ioe-lkml@rameria.de> <4844BB41.7000605@qualcomm.com> <4845D825.6000403@qualcomm.com> <20080603194148.56dfebe1.pj@sgi.com> <48461ADA.8020303@qualcomm.com> <877id5v1fg.fsf@basil.nowhere.org> <20080604124126.0d281a99.pj@sgi.com> <4846DF25.4020300@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846DF25.4020300@qualcomm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You do not even need to replace /sbin/init for this, no ?
> Simply installing custom
> 	/etc/init.d/create_cpusets
> with priority 0
> 	# chkconfig: 12345 0 99
> will do the job.
> 
> That script will move init itself into the appropriate cpuset and from then on
> everything will inherit it.

It won't be the parent of the other init scripts.

-Andi

