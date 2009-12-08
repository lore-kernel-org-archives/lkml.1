Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZLHMW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZLHMW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZLHMW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:22:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:7871 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbZLHMW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jviMKC9EMVxNKNsE5ZQDWm1/0hKwQ4cF39awYF05yQsP7N+VTBYYq+43Ddns6/KZXE
         v/G1OjZJ9njLmbpdW2r1sutRv4e9DB7khhOZlpstHx3EmbHiYsFONj9AzW9o82V44RNG
         /ikvYeyddOLgqlf0gOwBFCjrXtPupnYyRKadw=
Date: Tue, 8 Dec 2009 13:23:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] tracing: various cleanups and small fixes
	(updated)
Message-ID: <20091208122255.GB5016@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DC476.3030700@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:13:58AM +0800, Li Zefan wrote:
> Updates:
> 
> - took a further step to save more spaces (01/13)
> - fixed a mistake in (03/13)
> - collected some ACKs
> 
> 
> Here are some patches that I've collected. All are cleanups and
> small fixes, no change in functionality.
> 
> As a result, 24K bytes are saved, and 87 lines of code are
> reduced:
> 
>    text    data     bss     dec     hex filename
> 5355293 1961928 7103260 14420481         dc0a01 vmlinux.o.old
> 5331208 1961864 7103260 14396332         dbabac vmlinux.o
> 
> ---
>  include/linux/ftrace_event.h       |    4 +-
>  include/linux/syscalls.h           |    6 +-
>  include/trace/ftrace.h             |   56 ++-----------
>  kernel/trace/ftrace.c              |   30 ++++---
>  kernel/trace/power-traces.c        |    2 -
>  kernel/trace/trace.c               |  166 +++++++++++++-----------------------
>  kernel/trace/trace.h               |   23 +++---
>  kernel/trace/trace_event_profile.c |    6 +-
>  kernel/trace/trace_events.c        |   38 +++++++--
>  kernel/trace/trace_export.c        |    4 -
>  kernel/trace/trace_kprobe.c        |    9 --
>  kernel/trace/trace_ksym.c          |   13 ++--
>  kernel/trace/trace_syscalls.c      |   18 +----
>  13 files changed, 144 insertions(+), 231 deletions(-)


I'm queuing these patches.

Thanks.

