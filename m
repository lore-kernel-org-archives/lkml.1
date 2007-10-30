Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbXJ3RZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbXJ3RZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbXJ3RZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:25:38 -0400
Received: from gw.goop.org ([64.81.55.164]:47896 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbXJ3RZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:25:38 -0400
Message-ID: <4727690F.4030502@goop.org>
Date: Tue, 30 Oct 2007 10:25:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: tgh <wwwwww4187@sina.com.cn>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Xen-devel <xen-devel@lists.xensource.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [Xen-devel] [patch 30/44] xen: Add support for preemption
References: <20070716231536.937393000@xensource.com>> <20070716232915.672717000@xensource.com>> <4726F51C.4030709@sina.com.cn>
In-Reply-To: <4726F51C.4030709@sina.com.cn>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tgh wrote:
> hi
> I am using xen,and I am curious about whether Xen support the preempt
> scheduler for the VMs or not
> could the VM be prempted by xen to scheduler another VM?
>   

Yes, that's the normal mode of operation. The hypervisor will timeslice
multiple vcpus onto a single vcpu.

This patch doesn't relate to that; it's whether a Xen Linux guest's
kernel can be preempted to reschedule processes while running under Xen.
The normal xen-unstable or vendor Xen kernels don't support this, but
the mainline kernel with paravirt_ops/xen support does.

J
