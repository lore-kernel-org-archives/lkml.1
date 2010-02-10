Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0BJDAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:00:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJDAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:00:18 -0500
X-Authority-Analysis: v=1.0 c=1 a=4nqvKdf4PeEA:10 a=7U3hwN5JcxgA:10 a=Jf3bc1Y4yECTdCl6oeMA:9 a=4ehhJnYKBJtp6Ib1xqwA:7 a=CBrcEPdBavq7Vkd26oXSRATRW-kA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       mhiramat@redhat.com
In-Reply-To: <20100208171113.GD2688@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com>
	 <ce5ccbcc86e34954948239b17010c5537fb62917.1265142153.git.jbaron@redhat.com>
	 <20100203130104.GB30003@osiris.boeblingen.de.ibm.com>
	 <20100208154856.GC2688@redhat.com> <4B704188.4020009@oracle.com>
	 <20100208171113.GD2688@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 09 Feb 2010 22:00:13 -0500
Message-ID: <1265770813.24386.48.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 12:11 -0500, Jason Baron wrote:

> Most of the copat syscall are currently not using the 'SYCALL_DEFINE()'
> family of macros. For my purposes, the use of these macros allows them
> to be tied into the event tracing system. These macros append 'sys_' to
> the begging of the system call name. However, for compat syscall which
> are named 'sys32_blah', these macros are not sufficient. Thus, the need
> to introduce some new macros for the compat syscalls. 
> 
> > The added level of indirection makes problems for scripts/kernel-doc (well, if any of
> > the syscalls have kernel-doc notation, that is).  I'd prefer not to see 2 levels of macros
> > for defining a syscall, but if it has to live, please look into updating scripts/kernel-doc
> > also.
> > 
> 
> good point. I'll make sure the docs work properly.

Could you also make sure 'make TAGS' is updated too.
See scripts/tags.sh and search for SYSCALL

-- Steve


