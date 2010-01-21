Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701Ab0AUNXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0AUNXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358Ab0AUNXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:23:05 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:43990 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0AUNXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:23:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fEmF7fRLDcaGgKMrNclsJqL80EzGKRxGJgX1bRYfc2g+mvVML04cmjRNHXlJJHj6eO
         AwacHMJdIuWRJVVpNyky1LrAXRq0aS1g2No66tzcw+ZgbhWVLrjatZnysW2IElLzKVaq
         Ei2Xxf49QBUtVBlpzDvZRGLdHTcWLpSkTo9kg=
Date: Thu, 21 Jan 2010 14:22:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing, function_graph: simplify test for tracing
Message-ID: <20100121132255.GI5017@nowhere>
References: <4B4DB0B6.7040607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DB0B6.7040607@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 07:38:30PM +0800, Lai Jiangshan wrote:
> 
> For function_graph, a calling function is to be traced only when
> it is enabled or it is nested in a enabled function.
> 
> Current code uses TSK_TRACE_FL_GRAPH to test whether it is nested or not.
> read the code, we can get this:
> (trace->depth > 0) <==> (TSK_TRACE_FL_GRAPH is set)
> 
> trace->depth is more explicit to tell that it is nested.
> So we use trace->depth directly and simplify the code.
> 
> No functionality is changed.
> TSK_TRACE_FL_GRAPH is not removed now, it is left for future usage.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---



I've queued it. Thanks.

