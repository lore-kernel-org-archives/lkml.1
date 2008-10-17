Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbYJQQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbYJQQTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYJQQS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:18:59 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:54964 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbYJQQS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:18:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAIdR+EhMQWq+/2dsb2JhbACBcr8Tg2w
Date: Fri, 17 Oct 2008 12:18:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "William L. Irwin" <wli@holomorphy.com>
Subject: Re: [RFC patch 06/15] LTTng build
Message-ID: <20081017161852.GB5696@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234656.385520321@polymtl.ca> <20081017170830.E22D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081017170830.E22D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:18:35 up 134 days, 20:59,  9 users,  load average: 0.43, 0.91,
	1.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> just nit
> 
> > Index: linux-2.6-lttng/Makefile
> > ===================================================================
> > --- linux-2.6-lttng.orig/Makefile	2008-10-16 18:16:33.000000000 -0400
> > +++ linux-2.6-lttng/Makefile	2008-10-16 18:16:38.000000000 -0400
> > @@ -619,7 +619,7 @@ export mod_strip_cmd
> >  
> >  
> >  ifeq ($(KBUILD_EXTMOD),)
> > -core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> > +core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ ltt/
> >  
> >  vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
> >  		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
> 
> This patch depend on 07/15. it seems wrong patch order.
> Then it cause following build error.
> 

Will fix in the next release, thanks !

Mathieu

> 
> ~/linux/linux-2.6.27-lttng% make
> make
> make[1]: `include/asm-ia64/nr-irqs.h' is up to date.
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> scripts/Makefile.build:41: /mnt/sdb1/kosaki/linux/linux-2.6.27-lttng/ltt/Makefile: No such file or directory
> make[1]: *** No rule to make target `/mnt/sdb1/kosaki/linux/linux-2.6.27-lttng/ltt/Makefile'.  Stop.
> make: *** [ltt] Error 2
> 
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
