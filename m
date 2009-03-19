Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbZCSXwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbZCSXwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761790AbZCSXwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:52:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761621AbZCSXwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:52:35 -0400
Date: Thu, 19 Mar 2009 19:52:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/7] tracing: give easy way to clear trace buffer
In-Reply-To: <20090319202631.GA5935@nowhere>
Message-ID: <alpine.DEB.2.00.0903191952000.13615@gandalf.stny.rr.com>
References: <20090319200122.512803803@goodmis.org> <20090319200159.932486704@goodmis.org> <20090319202631.GA5935@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 19 Mar 2009, Frederic Weisbecker wrote:
> >  
> > +static ssize_t
> > +tracing_write_stub(struct file *filp, const char __user *ubuf,
> > +		   size_t count, loff_t *ppos)
> > +{
> > +	return count;
> > +}
> 
> 
> Is this one necessary?
> I guess debugfs or vfs layers already provide a stub for write. No?

Hmm, I wasn't sure if it supplied one or not. I probably should look ;-)

> 
> Anyway, that's a small detail for this good patch idea.
> 

Thanks,

-- Steve

