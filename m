Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbZE0Osh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbZE0Osh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbZE0Os1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:48:27 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36855 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbZE0Os0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XvnB2XSeDR/U8OUlZ+6gSPJRJYnihanBCi6haqH6aTYBeFzi0C2s4i0Bv5S383+XpB
         NpEDqP9AyatF6GIkLdkmTcQCN397Ic3DF+x60r+S4n3vcGYYe+PTYXwUUqMa+7YPfNdr
         R4honIYP1KHahK8S8cE4HY+8fQ/aJt/5OqDMw=
Date: Wed, 27 May 2009 16:48:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Anton Blanchard <anton@samba.org>, rostedt@goodmis.org, mingo@elte.hu,
       tzanussi@gmail.com, jbaron@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer
	tracepoints
Message-ID: <20090527144822.GC5982@nowhere>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten> <20090526180600.GA5969@nowhere> <4A1D07C8.6010002@cn.fujitsu.com> <alpine.LFD.2.00.0905271619360.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905271619360.3397@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 04:22:28PM +0200, Thomas Gleixner wrote:
> On Wed, 27 May 2009, Xiao Guangrong wrote:
> > In fact, Anton Blanchard's is different from my patch.
> > My patch is used for trace timer lifecycle(init/start/expire/cancel), and his
> > patch is mostly used for trace the execution time of timer function.
> 
> Right, but they should be combined into one set.


Ok.

 
> Frederic, can you please pick up Anton's patch right away so Xiao can
> work on top of it and add the init/start/cancel instrumentation.
> 
> Thanks,
> 
> 	tglx


Sure. I've applied it on
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/timer

Xiao can work on top of it.
This is a branch made against tip:/tracing/core

Frederic.

