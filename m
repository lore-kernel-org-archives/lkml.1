Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbZHTIIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbZHTIIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZHTIIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:08:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:42430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZHTIIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:08:12 -0400
Subject: Re: ATI driver conflict with LOCK_STAT
From: Peter Zijlstra <peterz@infradead.org>
To: Bowen <zbw1983@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E9D727BD-78FC-4D85-9841-34A8F41613BB@gmail.com>
References: <E9D727BD-78FC-4D85-9841-34A8F41613BB@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Aug 2009 10:08:19 +0200
Message-Id: <1250755699.8282.115.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 11:04 +0800, Bowen wrote:
> Hi All:
> 
> 	I just found that I can't compile my ATI driver. I have downloaded a  
> ATI driver from their web site, but I can't compile it successfully,  
> it reported "FATAL: modpost: GPL-incompatible module fglrx.ko uses  
> GPL-only symbol
> 'lock_acquire'",
> 
> 	I found when I close LOCK_STAT, I can compiled ATI driver  
> successfully. And I also try to remove GPL declaration from  
> "lock_acquire, lock_release, rcu_lock_map, lockdep_init_map", I can  
> also use ATI driver. So does anybody meet same problem? Should we  
> remove GPL limitation from those functions in kernel? Or just make  
> ATI driver conflict with LOCK_STAT?

Yay, I broke binary junk, +1 to me!!

Seriously though, use the opensource driver already :-)
