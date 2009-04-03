Return-Path: <linux-kernel-owner+w=401wt.eu-S936302AbZDCU11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936302AbZDCU11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbZDCU1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:27:18 -0400
Received: from relay3.sgi.com ([192.48.156.57]:60241 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753846AbZDCU1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:27:17 -0400
Date: Fri, 3 Apr 2009 15:27:07 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [tip:x86/uv] x86, UV: Fix for nodes with memory and no cpus
Message-ID: <20090403202707.GA30764@sgi.com>
References: <20090330140111.GA18461@sgi.com> <tip-6a891a24e4d0056c365a90ff2d71c38fd366b0d0@git.kernel.org> <20090403200538.GA11301@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403200538.GA11301@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 10:05:38PM +0200, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > Commit-ID:  6a891a24e4d0056c365a90ff2d71c38fd366b0d0
> > Gitweb:     http://git.kernel.org/tip/6a891a24e4d0056c365a90ff2d71c38fd366b0d0
> > Author:     Jack Steiner <steiner@sgi.com>
> > AuthorDate: Mon, 30 Mar 2009 09:01:11 -0500
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 3 Apr 2009 19:49:58 +0200
> > 
> > x86, UV: Fix for nodes with memory and no cpus
> 
> Hm, there's a build failure regression here:
> 
> arch/x86/kernel/apic/x2apic_uv_x.c: In function ???uv_system_init???:
> arch/x86/kernel/apic/x2apic_uv_x.c:641: error: implicit declaration of function ???node_start_pfn???

What was the config? Looks like node_start_pfn() is not defined for non-NUMA?
If your config was non-NUMA, I'll make UV depend on NUMA.


--- jack
