Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbYKYMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbYKYMYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 07:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYKYMYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 07:24:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48210 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYKYMYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 07:24:03 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>, fche@redhat.com (Frank Ch. Eigler)
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API : trace_mark_tp())
Cc: kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20081116075928.GB530@elte.hu>
References: <20081114224948.134716055@polymtl.ca> <20081116075928.GB530@elte.hu>
Message-Id: <20081125211750.26F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 21:23:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for very late responce.
However, if you do marker removing disucussion, I hope CC to Frank Eigler.
because SystemTap also use marker and tracepoint.
and this patch also improvement SystemTap marker support, I think.

IIRC, Currently, Systemtap also have marker/tracepoint on/off
syncronization problem.


> > Add a new API trace_mark_tp(), which declares a marker within a 
> > tracepoint probe. When the marker is activated, the tracepoint is 
> > automatically enabled.
> > 
> > No branch test is used at the marker site, because it would be a 
> > duplicate of the branch already present in the tracepoint.
> > 
> > Impact: new API.
> 
> i dont know.
> 
> I was actually hoping for markers (the in-kernel API) to go away 
> completely - and be replaced with tracepoints.
> 
> Markers are the wrong design on several levels. They couple the kernel 
> dynamically with unknown (to the kernel) entities - and that is 
> causing complexity all around the place, clearly expressed in these 
> patches of yours.
> 
> Tracepoints are much more specific - typed and enumerated function 
> call callback points in essence - with some politeness that allows 
> external instrumentation entities to attach to those callbacks.
> 
> Is there any usecase of markers that should not be converted to either 
> tracepoints or to ftrace_printk() ?

Frank, Could you please read this thread and give us your comment?



