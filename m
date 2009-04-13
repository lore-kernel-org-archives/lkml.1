Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZDMOoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZDMOoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZDMOnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:43:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZDMOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:43:50 -0400
Subject: Re: [PATCH] tracing: mark get_parent_ip() notrace
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49E2D8E3.4060708@cn.fujitsu.com>
References: <49D458B1.5000703@cn.fujitsu.com>
	 <20090402122612.GB5965@nowhere>  <49E2D8E3.4060708@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 13 Apr 2009 10:43:33 -0400
Message-Id: <1239633813.21121.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-04-13 at 14:17 +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > On Thu, Apr 02, 2009 at 02:18:25PM +0800, Lai Jiangshan wrote:
> >> Impact: remove redundancy tracing log
> >>
> >> When tracer is "function" or "function_graph", too much
> >> "get_parent_ip" are recorded in ring_buffer.
> > 
> > 
> > Thanks, indeed this get_parent_ip was a bit harrassing
> > in the traces, though I still don't understand why it is
> > called so often.
> > 
> > Anyway, tracing it seems to me not useful.
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > 
> 
> Hi, Ingo,
> 	Could you apply this fix?
> 
> get_parent_ip() is a helper function for ftace, and it is called
> by preempt_disable() and preempt_enable(), so it is occurred very
> often.

I can pull it in too, if Ingo is busy.

-- Steve


