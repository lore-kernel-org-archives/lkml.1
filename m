Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZLBGOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZLBGOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZLBGOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:14:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:17848 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZLBGOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:14:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IJLE+Kj1fxuRunMYVVsGS2U/ukOCSEwScwtUphjBDFd9/OhFn1GwZ2+S6rwxIwH2E3
         pB+kSRtVGjEat9cdWb6i57vmoKngQzzgqdFu2/9rgS7iNGE5HTOdnaIw4Iil7Nv2UT5c
         R0JvRQiMQbuU0yf5VBORkEbvT8HHV9TAX2Xno=
Date: Wed, 2 Dec 2009 07:14:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace_output: change struct trace_seq's size to
	PAGE_SIZE
Message-ID: <20091202061423.GC5719@nowhere>
References: <4B10E1F0.80202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B10E1F0.80202@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 04:40:16PM +0800, Lai Jiangshan wrote:
> 
> It's not very good that we allocate pages with page_order > 1.
> So we change struct trace_seq's size to PAGE_SIZE.
> 
> Where we allocate a struct trace_seq:
> 
> kernel/trace/trace.c:3720:      s = kmalloc(sizeof(*s), GFP_KERNEL);
> kernel/trace/trace_events.c:539:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> kernel/trace/trace_events.c:580:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> kernel/trace/trace_events.c:604:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> kernel/trace/trace_events.c:660:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> kernel/trace/trace_events.c:715:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> kernel/trace/trace_ksym.c:230:  s = kmalloc(sizeof(*s), GFP_KERNEL);
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>



Looks good to me.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Steve, any objection?

