Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZCGQDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZCGQDD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 11:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZCGQCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 11:02:53 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:38858 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZCGQCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 11:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A0on28FjphTSL+uhGvcm7OX106iTPctS+5BWysF0UROeARrtmKcmD6yPoq1/5HvBTV
         Yzhgbm/hFzQtxvcU0EMlLKJlRMdNZuFHShCWTJSG0GB5vpo5YfaY7AnBzuGzXwzYkxKv
         FVUNSYYeF5TcGBLvl8Yq7917LYti+l0qY6+Eo=
Date: Sat, 7 Mar 2009 17:02:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/2] Syscalls tracing
Message-ID: <20090307160246.GB6075@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236428118.6376.239.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236428118.6376.239.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 01:15:18PM +0100, Peter Zijlstra wrote:
> On Sat, 2009-03-07 at 05:52 +0100, Frederic Weisbecker wrote:
> > Here is a first attempt, quick one-shot, to provide a syscall tracing
> > infrastructure on ftrace.
> > 
> > The RFC prefix is here to reflect its ugliness on various parts.
> > The compromise between tracing reliabilty and speed is hard to balance.
> > For example I guess the basic and horrid string mask should be dropped in favour
> > of something else, which takes care of the volatile strings from the userspace.
> > 
> > But I hope a lot of ideas to make it better will come along this discussion.
> 
> Can't you abuse the SYSCALL_DEFINE macros? This current approach looks
> like it will replicate the syscall table.
> 


Ah, I did not even think about it.
I will be able to get the number of parameters. Sounds good. But I will
still need a way to store their format somewhere.

