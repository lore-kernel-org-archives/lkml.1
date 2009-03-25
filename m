Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZCYRxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZCYRxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZCYRxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:53:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:44126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZCYRxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:53:32 -0400
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090324203259.GC26930@elte.hu>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 17:53:01 +0000
Message-Id: <1238003581.2085.53.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 21:32 +0100, Ingo Molnar wrote:
> (Cc:s added)
> 
> * Andrew Lutomirski <amluto@gmail.com> wrote:
> 
> > On vanilla 2.6.29 (on Ubuntu 8.10), on a Lenovo x200s, my system 
> > is completely hosed on resume.  It appears that even hard disk IO 
> > didn't work (trying to do *anything* including getting a dmesg 
> > trace just spewed sda io errors to the console).  Hence no trace.  
> > I did an alt-sysrq-b and the screen went blank and the machine 
> > just started beeping at me.
> > 
> > Resume works much better with intel_iommu=off.  (I remember seeing 
> > a patch go by that purported to fix resume with IOMMU enabled, but 
> > it didn't work for me.)
> > 
> > I'd be happy to try to make a better bug report if anyone has any 
> > bright ideas.
> 
> i have a Lenovo T500 that does not even boot with with DMAR enabled 
> in the BIOS (it's default-off), i get this panic in early bootup:
> 
>     DMAR hardware is malfunctioning

Can you show me the output of the pr_debug() statement at dmar.c:543 (in
alloc_iommu()? 

And bring me the head of a BIOS author.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

