Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbXFKStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbXFKStS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXFKStK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:49:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbXFKStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:49:08 -0400
Date: Mon, 11 Jun 2007 11:48:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       efault@gmx.de, kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com
Subject: Re: [RFC][PATCH 1/6] Introduce struct sched_entity and struct lrq
In-Reply-To: <20070611155046.GA2109@in.ibm.com>
Message-ID: <alpine.LFD.0.98.0706111146220.14121@woody.linux-foundation.org>
References: <20070611154724.GA32435@in.ibm.com>
 <20070611155046.GA2109@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Jun 2007, Srivatsa Vaddagiri wrote:
> 
> struct sched_entity
>         stores essential attributes/execution-history used by CFS core
>         to drive fairness between 'schedulable entities' (tasks, users etc)

Wouldn't this be sensible to integrate into CFS _regardless_ of anything 
else?

Especially with the alleged "pluggable" scheduler model, one of the things 
lacking in any pluggability is the fact that the core thread data 
structures are anythign but pluggable. This patch makes it no more so, but 
at least it abstracts out the fields that are used by the scheduler, and 
would seem to be a nice cleanup. No?

		Linus
