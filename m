Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZGWVll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZGWVll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZGWVlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:41:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59003 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZGWVlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:41:40 -0400
Date: Thu, 23 Jul 2009 17:41:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 04/13] ftrace: perf_counter intergration
In-Reply-To: <20090723191956.941061118@chello.nl>
Message-ID: <alpine.DEB.2.00.0907231741060.2498@gandalf.stny.rr.com>
References: <20090723191642.780643661@chello.nl> <20090723191956.941061118@chello.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Jul 2009, Peter Zijlstra wrote:

> Adds possible second part to the assign argument of TP_EVENT().
> 
>   TP_perf_assign(
> 	__perf_count(foo);
> 	__perf_addr(bar);
>   )
> 
> Which, when specified make the swcounter increment with @foo instead
> of the usual 1, and report @bar for PERF_SAMPLE_ADDR (data address
> associated with the event) when this triggers a counter overflow.

Looks good,

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
