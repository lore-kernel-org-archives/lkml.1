Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbYARK0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbYARK0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759887AbYARK0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:26:32 -0500
Received: from ozlabs.org ([203.10.76.45]:42878 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbYARK0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:26:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18320.32464.634534.415458@cargo.ozlabs.ibm.com>
Date: Fri, 18 Jan 2008 21:26:24 +1100
From: Paul Mackerras <paulus@samba.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel oops will running kernbench
In-Reply-To: <479072BC.3080908@linux.vnet.ibm.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<479064F0.7040305@linux.vnet.ibm.com>
	<20080118004416.6a757169.akpm@linux-foundation.org>
	<18320.27372.202771.764301@cargo.ozlabs.ibm.com>
	<479072BC.3080908@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal writes:

> >>> NIP: 0000000000004570 LR: 000000000fc42dc0 CTR: 0000000000000000
> >>> REGS: c00000077b6bf8c0 TRAP: 0300   Not tainted  (2.6.24-rc8-mm1-autotest)
> >>> MSR: 8000000000001000 <ME>  CR: 28022422  XER: 00000000
> >>> DAR: c00000077b6bfce0, DSISR: 000000000a000000

Actually, how much RAM does this machine have?  If it has less than
32GB, then the problem is that the kernel stack pointer is bogus.
(How it got to be bogus is the interesting question, of course. :)

Paul.

