Return-Path: <linux-kernel-owner+w=401wt.eu-S1945898AbXC2WLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945898AbXC2WLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945896AbXC2WLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:11:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49407 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945895AbXC2WLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:11:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<20070329182020.GA9223@aitel.hist.no>
	<20070329142816.5d18d89f.akpm@linux-foundation.org>
Date: Thu, 29 Mar 2007 16:10:50 -0600
In-Reply-To: <20070329142816.5d18d89f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 29 Mar 2007 14:28:16 -0700")
Message-ID: <m1mz1vem51.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Ah.  I assume you have CONFIG_SYSCTL=y, CONFIG_PROC_SYSCTL=n?
>
>
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> We're using #ifdef CONFIG_SYSCTL, but we should be using CONFIG_PROC_SYSCTL,
> so we get

I have no problem with the patch it is clearly more correct than what we
are doing now but I didn't think it was possible to select
CONFIG_SYSCTL and CONFIG_PROCFS without CONFIG_PROC_SYSCTL being
selected...
Do we have a constraint problem in Kconfig?  Or am I misremembering things?

>  fs/built-in.o: In function `proc_root_init':
>  /usr/src/linux/fs/proc/root.c:83: undefined reference to `proc_sys_init'
>
> Fix that up and remove an ifdef-in-C.
>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Helge Hafting <helgehaf@aitel.hist.no>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Eric
