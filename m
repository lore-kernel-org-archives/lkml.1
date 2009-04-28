Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbZD1KPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbZD1KPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZD1KOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:14:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40783 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbZD1KOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:14:52 -0400
Date: Tue, 28 Apr 2009 12:18:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?B?RnLpppjpp7tpYw==?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428101851.GM27382@one.firstfloor.org>
References: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com> <20090428092918.GC21085@elte.hu> <20090428183237.EBDE.A69D9226@jp.fujitsu.com> <20090428093833.GE21085@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428093833.GE21085@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But it has to be expressed in one framework that cares about the 
> totality of the kernel - not just these splintered bits of 

Can you perhaps expand a bit what code that framework would
provide to kpageflags? As far as I can see it only needs
a ->read callback from somewhere and I admit it's hard to see for me
how that could share much code with anything else.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
