Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYCLRvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYCLRvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYCLRvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:51:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33482 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYCLRvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:51:04 -0400
Date: Wed, 12 Mar 2008 11:51:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.25-rc5-mm1 kernel panic with "Exception: 501 " on powerpc
Message-ID: <20080312175102.GC613@parisc-linux.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D7D2C9.4090001@linux.vnet.ibm.com> <20080312104645.34e58319.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312104645.34e58319.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 10:46:45AM -0700, Andrew Morton wrote:
> On Wed, 12 Mar 2008 18:25:37 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Beats me.  Maybe we're still enabling interrupts too early.  But the new
> semaphore code got fixed (didn't it?)

On the 7th, according to my records.  Easy to check -- look in
kernel/semaphore.c and see whether down() is using spin_lock_irqsave
(good) or spin_lock_irq (bad).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
