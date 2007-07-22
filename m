Return-Path: <linux-kernel-owner+w=401wt.eu-S1765095AbXGVM7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765095AbXGVM7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761001AbXGVM65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:58:57 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:41226 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbXGVM64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:58:56 -0400
Date: Sun, 22 Jul 2007 15:58:48 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: do_swap_page() and !CONFIG_SWAP
Message-ID: <20070722125848.GA6182@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is there any valid reason (except memory corruption) for do_swap_page() 
to be called in a x86_64 2.6.21.5 kernel where CONFIG_SWAP is not selected?

If not, does it make sense to put there something in lines of:

       print_bad_pte(vma, orig_pte, address);
       panic("unexpected swap pte - possible page table memory corruption\n");

?

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
