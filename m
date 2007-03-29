Return-Path: <linux-kernel-owner+w=401wt.eu-S1945901AbXC2WX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945901AbXC2WX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945905AbXC2WX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:23:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35124 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945901AbXC2WX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:23:58 -0400
Date: Thu, 29 Mar 2007 15:24:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
Message-Id: <20070329152455.1be1fe2f.randy.dunlap@oracle.com>
In-Reply-To: <m1mz1vem51.fsf@ebiederm.dsl.xmission.com>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<20070329182020.GA9223@aitel.hist.no>
	<20070329142816.5d18d89f.akpm@linux-foundation.org>
	<m1mz1vem51.fsf@ebiederm.dsl.xmission.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 16:10:50 -0600 Eric W. Biederman wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > Ah.  I assume you have CONFIG_SYSCTL=y, CONFIG_PROC_SYSCTL=n?
> >
> >
> >
> >
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> > We're using #ifdef CONFIG_SYSCTL, but we should be using CONFIG_PROC_SYSCTL,
> > so we get
> 
> I have no problem with the patch it is clearly more correct than what we
> are doing now but I didn't think it was possible to select
> CONFIG_SYSCTL and CONFIG_PROCFS without CONFIG_PROC_SYSCTL being
> selected...
> Do we have a constraint problem in Kconfig?  Or am I misremembering things?

Hi Eric,

Looks like you are just misremembering things...

> >  fs/built-in.o: In function `proc_root_init':
> >  /usr/src/linux/fs/proc/root.c:83: undefined reference to `proc_sys_init'
> >
> > Fix that up and remove an ifdef-in-C.
> >
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Helge Hafting <helgehaf@aitel.hist.no>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
