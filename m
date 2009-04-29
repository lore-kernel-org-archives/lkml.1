Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZD2Pmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZD2Pmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZD2Pmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:42:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025AbZD2Pmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:42:44 -0400
Date: Wed, 29 Apr 2009 08:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
 for per worklet
Message-Id: <20090429083654.7ecf0100.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904290944290.8066@gandalf.stny.rr.com>
References: <49F6DFB5.2040901@cn.fujitsu.com>
	<20090429000616.f7e72b73.akpm@linux-foundation.org>
	<20090429133342.GA5987@nowhere>
	<alpine.DEB.2.00.0904290944290.8066@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 09:45:28 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 29 Apr 2009, Frederic Weisbecker wrote:
> >  * pointer to the real address.
> > 
> > But the output formatting is the same: address, offset, size, modname.
> > 
> > I found it a bit annoying, so I proposed the following patch recently:
> > 
> > http://lkml.org/lkml/2009/4/15/310

This looks OK.  I'd assumed it was merged.  Was there a problem with it?

> > And someone came with a better idea, IMO:
> > 
> > http://lkml.org/lkml/2009/4/17/105
> 
> Note,
> 
> If these ever do get merged, I would be happy to convert ftrace to use 
> them to replace my version.

I spose I could use magic powers to sneak it into .30?
