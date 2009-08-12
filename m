Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbZHLVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbZHLVfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZHLVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:35:50 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:36558 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZHLVft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wDVb2K4Uv8wytYzllyiDS0YS2I5e9pozInRL66oY0+jVhHuCImvEo3uSXUGy1gIAFn
         B7h+CoZAcad6qCji2p++TWLIiymML0M5pLdltw/w/pGZjnlI30oKwEcHva6vTPHV30m1
         u6DdZkmRoG26W68UnQNM/zpqzyARrStARAb44=
Date: Wed, 12 Aug 2009 23:35:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFD] Kprobes/Kretprobes perf support
Message-ID: <20090812213545.GC5974@nowhere>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com> <20090812191305.GB5974@nowhere> <1250111397.7035.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250111397.7035.1.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:09:57PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-08-12 at 21:13 +0200, Frederic Weisbecker wrote:
> 
> > Ingo, Peter do you have an idea on how we could do that?
> 
> Wouldn't it be easiest to use ftrace to create dynamic tracepoints in
> the ftrace way such that they become available in
> debugfs://tracing/events/kprobes/*/ and then have them interfaced the
> same way as all other tracepoints?
> 


Oh..yeah, that would be definetly simpler.

