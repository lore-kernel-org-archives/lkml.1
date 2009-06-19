Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbZFSDeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbZFSDeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZFSDeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:34:00 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:39476 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZFSDd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mJi46AKhc+2s860Zdh+M7Gpaigmrg19Ji3hhrexthKhuObf8t2rGw/c3QB4kFYrp0k
         9588GupklgYJBXcm8EiW0S0Ina/qLUIytydwsMzfllnVegP/sRIpnaD5jlY86jEZ5Qdc
         0zbUAzLpXrRRwRgMrz+1qtpOkse0tr9RmUHBg=
Date: Fri, 19 Jun 2009 05:33:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       bligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 5/7] add syscall tracepoints
Message-ID: <20090619033358.GI7903@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <51b4e9aff767dac4933ebb7835dee7068b158db8.1244837725.git.jbaron@redhat.com> <20090619021418.GC7903@nowhere> <4A3B028C.2040902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3B028C.2040902@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 11:14:20AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Fri, Jun 12, 2009 at 05:24:59PM -0400, Jason Baron wrote:
> >> update FTRACE_SYSCALL_MAX to the current number of syscalls
> >>
> >>
> >> Signed-off-by: Jason Baron <jbaron@redhat.com>
> >>
> >> ---
> >>  arch/x86/include/asm/ftrace.h |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> >> index bd2c651..d16d195 100644
> >> --- a/arch/x86/include/asm/ftrace.h
> >> +++ b/arch/x86/include/asm/ftrace.h
> >> @@ -30,9 +30,9 @@
> >>  
> >>  /* FIXME: I don't want to stay hardcoded */
> > 
> > 
> > BTW, is there a way to know this size dynamically?
> > Or is there already a hardcoded number of syscalls somewhere
> > in x86?
> > 
> 
> Does this patchset head for .31 or .32? If for .32, then this patch should
> go into .31 I think.


Hmm, I was thinking about .32 but if Ingo has the time to test it and
if he agrees with it, why not.

