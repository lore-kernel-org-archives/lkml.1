Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXFUQya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXFUQya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbXFUQyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:54:23 -0400
Received: from rtr.ca ([64.26.128.89]:1708 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXFUQyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:54:22 -0400
Message-ID: <467AAD3C.8020200@rtr.ca>
Date: Thu, 21 Jun 2007 12:54:20 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, davej@redhat.com,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Change in default vm_dirty_ratio
References: <1182201271.4883.22.camel@localhost.localdomain>	<20070618164711.9de1c38e.akpm@linux-foundation.org>	<20070620042434.GC12096@redhat.com>	<20070619214407.dfff0ca6.akpm@linux-foundation.org>	<1182328536.21117.24.camel@twins> <20070620015826.03f1d71a.akpm@linux-foundation.org>
In-Reply-To: <20070620015826.03f1d71a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
> What do we actually want the kernel to *do*?  Stated in terms of "when the
> dirty memory state is A, do B" and "when userspace does C, the kernel should
> do D".

When we have dirty pages awaiting write-out,
and the write-out device is completely idle,
then we should be writing them out.

That's the easy bit taken care of.  ;)
