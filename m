Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZHTLeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZHTLeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZHTLeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:34:21 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54822 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbZHTLeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WdU2b/txCbCsx4eTWK3YBrTpcsMJeuu+NhDUwEw+DaETKL5fu5eLfkPF9+/QKxFdwR
         VwwHPjOI4/LIUcuRuiwq8FxkriJOz39za06hl6uijx/vh92WlBSVIjmDsB+C2AyoXoTB
         E+DsyPmatJfYuRT14DuhuPeGHJpoagu0KKss8=
Date: Thu, 20 Aug 2009 13:34:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/syscalls: Fix the output of syscalls with no
	arguments
Message-ID: <20090820113415.GA6069@nowhere>
References: <4A8CAE0C.9040107@cn.fujitsu.com> <4A8D05AF.20103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8D05AF.20103@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 04:13:35PM +0800, Li Zefan wrote:
> Before:
> 
>   # echo 1 > events/syscalls/sys_enter_sync/enable
>   # cat events/syscalls/sys_enter_sync/format
>   ...
>         field:int nr;   offset:12;      size:4;
> 
>   print fmt: "# sync
>   # cat trace
>   ...
>             sync-8950  [000]  2366.087670: sys_sync(
> 
> After:
> 
>   # echo 1 > events/syscalls/sys_enter_sync/enable
>   # cat events/syscalls/sys_enter_sync/format
>   ...
>         field:int nr;   offset:12;      size:4;
> 
>   print fmt: ""
>   # sync
>   # cat trace
>             sync-2134  [001]   136.780735: sys_sync()
> 
> Reported-by: Masami Hiramatsu <mhiramat@redhat.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---


Thanks for fixing this!

