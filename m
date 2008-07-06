Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYGFNqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYGFNqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYGFNqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:46:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36289 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbYGFNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:46:34 -0400
Message-ID: <4870CC94.8090504@garzik.org>
Date: Sun, 06 Jul 2008 09:45:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH #upstream-fixes] ahci: give another shot at clearing all
 bits in irq_stat
References: <20080704131005.GA30768@havoc.gtf.org> <alpine.LFD.1.10.0807040955100.2815@woody.linux-foundation.org> <486EE6CA.2040908@kernel.org> <486EE804.6020202@kernel.org> <486EF44A.20400@kernel.org>
In-Reply-To: <486EF44A.20400@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Commit ea0c62f7cf70f13a67830471b613337bd0c9a62e tried to clear all
> bits in irq_stat but it didn't actually achieve that as irq_stat was
> anded with port_map right after read.  This patch makes ahci driver
> always use the unmasked value to clear irq_status.
> 
> While at it, add explanation on the peculiarities of ahci IRQ
> clearing.
> 
> This was spotted by Linus Torvalds.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> The original report requires further investigation regarding why the
> bogus change fixed the problem but this change is the correct thing to
> do regardless.
> 
> Thanks.

Belated post-holiday ACK (since it's already in).

Thanks for taking care of this, and good catch too.

