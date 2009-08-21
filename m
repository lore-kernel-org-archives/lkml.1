Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbZHUUJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbZHUUJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbZHUUJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:09:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292AbZHUUJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:09:32 -0400
Date: Fri, 21 Aug 2009 16:08:19 -0400
From: Jason Baron <jbaron@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH v2 2/2] tracing: Create generic syscall TRACE_EVENTs
Message-ID: <20090821200819.GB7099@redhat.com>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250795373-32363-2-git-send-email-jistone@redhat.com> <20090821175737.GB2684@redhat.com> <4A8EF765.9050201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8EF765.9050201@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 12:37:09PM -0700, Josh Stone wrote:
> On 08/21/2009 10:57 AM, Jason Baron wrote:
> >> +TRACE_EVENT_WITH_CALLBACK(sys_enter,
> > 
> > don't we want to change this to something like 'sys_enter_generic'?
> > otherwise, looks good.
> 
> Since all of the specific events are named "sys_enter_foo", I thought
> that it would be clear that an unadorned "sys_enter" was the more
> generic syscall event.  Calling it "sys_enter_generic" seems to me by
> convention to mean a system call named "generic".
> 
> I don't want to bikeshed this though -- if you still think
> "sys_enter_generic" is better, then I'll change it.
> 

no I don't feel strongly about it...whatever the consensus is...

thanks,

-Jason
