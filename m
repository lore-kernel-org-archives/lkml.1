Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXBTVeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXBTVeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030434AbXBTVeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:34:25 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45825 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030419AbXBTVeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:34:24 -0500
Date: Tue, 20 Feb 2007 13:34:23 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
In-Reply-To: <45DB62B3.8060905@qualcomm.com>
Message-ID: <Pine.LNX.4.64.0702201333360.17198@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
 <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
 <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
 <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com>
 <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
 <45DB62B3.8060905@qualcomm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Max Krasnyansky wrote:

> I agree that running the reaper on the wrong CPU is not the best way to go
> about it.
> But it seems like disabling it is even worse, unless I missing something. ie
> wasting
> memory.

Disabling during shutdown is no problem because the per cpu caches are 
going to be drained anyways by the cpu down code.
