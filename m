Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYISUPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYISUPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYISUPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:15:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbYISUPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:15:11 -0400
Date: Fri, 19 Sep 2008 13:14:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and
 control (v4)
Message-Id: <20080919131405.1a95c491.akpm@linux-foundation.org>
In-Reply-To: <20080919063823.GA27639@balbir.in.ibm.com>
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain>
	<20080514130951.24440.73671.sendpatchset@localhost.localdomain>
	<20080918135430.e2979ab1.akpm@linux-foundation.org>
	<20080919063823.GA27639@balbir.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 23:38:23 -0700
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [2008-09-18 13:54:30]:
> 
> > On Wed, 14 May 2008 18:39:51 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > This patch adds support for accounting and control of virtual address space
> > > limits.
> > 
> > 
> > Large changes in linux-next's arch/x86/kernel/ptrace.c caused damage to
> > the memrlimit patches.
> > 
> > I decided to retain the patches because it looks repairable.  The
> > problem is this reject from
> > memrlimit-add-memrlimit-controller-accounting-and-control.patch:
> >
> 
> Andrew,
> 
> I could not apply mmotm to linux-next (both downloaded right now).

mmotm includes linux-next.patch.  mmotm is based upon the most recent
2.6.x-rcy.

This is the only way to do it - I often have to change linux-next.patch
due to rejects and it's unreasonable to expect people to base off the
same version of linux-next as I did.

> I
> applied the patches one-by-one resolving differences starting from #mm
> in the series file.
> 
> Here is my fixed version of the patch, I compiled the patch, but could
> not run it, since I could not create the full series of applied
> patches. I compiled arch/x86/kernel/ds.o and ptrace.o. I've included
> the patch below, please let me know if the code looks OK (via review)
> and the patch applies. I'll test it once I can resonably resolve all
> conflicts between linux-next and mmotm.

OK, we'll give it a shot, thanks.

