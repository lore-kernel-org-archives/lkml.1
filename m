Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbYGPQRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbYGPQRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbYGPQRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:17:17 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:46388 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734AbYGPQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:17:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEANG4fUhMRKxB/2dsb2JhbACBWq8a
Date: Wed, 16 Jul 2008 12:17:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 10/17] LTTng instrumentation - swap
Message-ID: <20080716161714.GA31889@Krystal>
References: <1216219654.5232.55.camel@twins> <20080716150046.GI24546@Krystal> <20080717004734.1579.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080717004734.1579.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:16:51 up 41 days, 20:57,  5 users,  load average: 0.39, 0.47,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> > > > Would it make more sense to turn get_swap_info_struct into a static
> > > > inline in swap.h ?
> > > 
> > > Seeing a consumer of it would go a long way towards discussing it ;-)
> > 
> > The LTTng probe which connects to this tracepoint looks like :
> 
> I have no objection to this exporting.
> 
> However, This is LTTng requirement.
> but tracepoint is tracer independent mechanism.
> then, split out is better IMHO.
> 

Good point. I'll move it to my following lttng-specific patches.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
