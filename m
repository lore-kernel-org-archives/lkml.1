Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbZFLQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbZFLQOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFLQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:14:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbZFLQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:14:06 -0400
Date: Fri, 12 Jun 2009 09:12:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when feature
 is disabled
In-Reply-To: <20090612154525.GA14438@elte.hu>
Message-ID: <alpine.LFD.2.01.0906120912000.3237@localhost.localdomain>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu> <20090612125741.GA6140@localhost> <20090612131754.GA32105@elte.hu> <20090612154525.GA14438@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, Ingo Molnar wrote:
> 
> What feels wrong to me is: kill a process and - in the case where 
> that process is restartable or expendable - suggest to the admin 
> that "everything is fine, we handled it just fine".

That is absolutely _not_ how any real-life sysadmin would ever react.

				Linus
