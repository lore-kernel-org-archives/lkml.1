Return-Path: <linux-kernel-owner+w=401wt.eu-S934670AbXHHXAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbXHHXAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbXHHW7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:59:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757296AbXHHW7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:59:52 -0400
Date: Wed, 8 Aug 2007 15:59:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: kvm warning
Message-Id: <20070808155901.bcb249d9.akpm@linux-foundation.org>
In-Reply-To: <46BA4827.3080907@qumranet.com>
References: <20070808151446.9a4eebda.akpm@linux-foundation.org>
	<20070808221956.GA16238@elte.hu>
	<46BA4827.3080907@qumranet.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2007 01:48:07 +0300
Avi Kivity <avi@qumranet.com> wrote:

> Ingo Molnar wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >   
> >> ia64 allmodconfig says
> >>
> >> drivers/kvm/Kconfig:14:warning: 'select' used by config symbol 'KVM' 
> >> refers to undefined symbol 'PREEMPT_NOTIFIERS'
> >>     
> >
> > hm, why doesnt ia64 pick up kernel/Kconfig.preempt, like all the other 
> > arches? Due to that ia64 also misses out on voluntary preempt and on 
> > preempt-bkl.
> >
> >   
> 
> Even more hm, how does ia64 manage to enable kvm?  It 'depends on X86' 
> at this moment.
> 

beats me.  CONFIG_KVM doesn't get set.  But it seems that kconfig wants
to do error-checking on that item anyway.



btw, testing of Kconfig can be done for any architecture without
installation of a toolchain for that architecture.  Set $ARCH and run
mrproper then use menuconfig/oldconfig/allmodconfig/allconfig as usual.

Judging by the number of Kconfig problem I see, this is a big secret ;)
