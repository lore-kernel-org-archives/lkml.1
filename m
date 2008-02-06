Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbYBFIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbYBFIYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbYBFIYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:24:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723AbYBFIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:24:11 -0500
Date: Wed, 6 Feb 2008 00:24:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: OOPS in sysctl.c
Message-Id: <20080206002420.91124dab.akpm@linux-foundation.org>
In-Reply-To: <200802051224.56413.hs4233@mail.mn-solutions.de>
References: <200802050845.58691.hs4233@mail.mn-solutions.de>
	<200802051224.56413.hs4233@mail.mn-solutions.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 12:24:56 +0100 Holger Schurig <hs4233@mail.mn-solutions.de> wrote:

> > I have an embedded target (PXA255 based) where I have a nice
> > running kernel 2.6.15. Today I'm trying to get 2.6.24 running
> > on it.
> 

Backtrace:
[<c0038bbc>] (sysctl_head_next+0x0/0x64) from [<c00a4b80>] (proc_sys_readdir+0x360/0x394)
 r4:00000000
[<c00a4820>] (proc_sys_readdir+0x0/0x394) from [<c007c860>] (vfs_readdir+0x70/0x98)
[<c007c7f0>] (vfs_readdir+0x0/0x98) from [<c007cdf0>] (sys_getdents64+0x6c/0xc0)
[<c007cd84>] (sys_getdents64+0x0/0xc0) from [<c0023e60>] (ret_fast_syscall+0x0/0x2c)

> Whatever the problem is, sysfs works now flawlessly even after
> a suspend/resume with v2.6.24-7284-g9ef9dc6.

erp.  We'd really like to know what we did to fix it, and then get that
fix back into 2.6.24.x.  
