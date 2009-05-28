Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbZE1O43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbZE1O43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZE1O4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:56:22 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:55392 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbZE1O4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=HLSv00rvwWDctyKxYGgzL2oT47Zx3zZXsafs6gKDLUJ1bp/5Lxj1jf8txZWgF3WLhk
         lKJHSkeUQJy+AV/N5iWPJLUyoQGgQXJ3FFyIQCqezk5gBEsFEMVTLXJh8zzrwbqyk8Q1
         7QZSwHgrxisDod5KzcSwRY9YnQxiYx0rdp19g=
Subject: Re: [PATCH] mips-specific ftrace support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <alpine.LFD.2.00.0905281644210.3397@localhost.localdomain>
References: <73465d64a9a6773936f5eab3735a69f651c13187.1243458732.git.wuzj@lemote.com>
	 <alpine.DEB.2.00.0905280948410.27708@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0905281644210.3397@localhost.localdomain>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Thu, 28 May 2009 22:56:05 +0800
Message-Id: <1243522565.5183.8.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 16:45 +0200, Thomas Gleixner wrote:
> On Thu, 28 May 2009, Steven Rostedt wrote:
> > On Thu, 28 May 2009, wuzhangjin@gmail.com wrote:
> > Could you possibly break this patch up into porting the tracers one by 
> > one. That is:
> > 
> > First patch: make function tracing work.
> > Second patch: make dynamic tracing work.
> > Third patch: add Function graph tracing.
> > Forth patch: the time stamp updates
> > 
> > This would make things a lot easier to review, and if one of the changes 
> > breaks something, it will be easier to bisect.
> 
> > >  include/linux/clocksource.h    |    4 +-
> > >  kernel/sched_clock.c           |    2 +-
> > >  kernel/trace/ring_buffer.c     |    3 +-
> > >  kernel/trace/trace_clock.c     |    2 +-
> > >  scripts/Makefile.build         |    1 +
> > >  scripts/recordmcount.pl        |   31 +++-
> 
> The changes to these generic files need to be separate as well.
> 

Acked, will update it later.

thanks!
Wu Zhangjin

