Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXJaBYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXJaBYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXJaBY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:24:27 -0400
Received: from gatekeeper.ncic.ac.cn ([159.226.41.188]:57833 "HELO ac.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752197AbXJaBY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:24:26 -0400
Message-ID: <4727D926.6050004@sina.com.cn>
Date: Wed, 31 Oct 2007 09:23:50 +0800
From: tgh <wwwwww4187@sina.com.cn>
User-Agent: Thunderbird 1.5.0.7 (Windows/20060909)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [Xen-devel] [patch 30/44] xen: Add support for preemption
References: <20070716231536.937393000@xensource.com>>	<20070716232915.672717000@xensource.com>>	<4726F51C.4030709@sina.com.cn> <4727690F.4030502@goop.org>
In-Reply-To: <4727690F.4030502@goop.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank for your reply
and I still have several questions
> Yes, that's the normal mode of operation. The hypervisor will timeslice
> multiple vcpus onto a single vcpu.
>   
that is ,the VM could be preempted by xen,and could xen hypervisor also
be preempted to reschedule other vm or xen kernel thread?and are there
the counterpart abstractions in xen for kernel thread in linux?

> This patch doesn't relate to that; it's whether a Xen Linux guest's
> kernel can be preempted to reschedule processes while running under Xen.
>   
that is ,the patch makes the guest's kernel, rather than xen, be able to
be preempted ,is it right?

Thanks in advance
> The normal xen-unstable or vendor Xen kernels don't support this, but
> the mainline kernel with paravirt_ops/xen support does.
>
> J
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>
>
>   

