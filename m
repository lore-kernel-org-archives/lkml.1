Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbYFDTpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbYFDTpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbYFDTp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:45:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18101 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYFDTp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:45:26 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5310"; a="3507564"
Message-ID: <4846F0DE.1070708@qualcomm.com>
Date: Wed, 04 Jun 2008 12:45:34 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: andi@firstfloor.org, ioe-lkml@rameria.de, sivanich@sgi.com,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>	<48447C75.8040203@qualcomm.com>	<200806030156.00155.ioe-lkml@rameria.de>	<4844BB41.7000605@qualcomm.com>	<4845D825.6000403@qualcomm.com>	<20080603194148.56dfebe1.pj@sgi.com>	<48461ADA.8020303@qualcomm.com>	<877id5v1fg.fsf@basil.nowhere.org>	<20080604124126.0d281a99.pj@sgi.com>	<4846DF25.4020300@qualcomm.com>	<20080604135826.f50f913a.pj@sgi.com>	<4846ED88.6040100@qualcomm.com> <20080604143743.b492c411.pj@sgi.com>
In-Reply-To: <20080604143743.b492c411.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
>> btw Are you guys using some kind of castrated, statically linked shell to run
>> that script ?
> 
> It (that init= program) is not a script.  It is its own
> castrated, statically linked special purpose binary.
> Once it has done its duty setting up cpusets, it then
> exec's the normal init, confined to the cpuset configured
> for it.

Got it.

Max
