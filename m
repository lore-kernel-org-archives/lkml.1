Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYGDK2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYGDK2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYGDK2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:28:44 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:56878 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYGDK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:28:43 -0400
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <DEA4DF93-2CC0-4F19-B1CC-59A737626D2B@freescale.com>
From: Timur Tabi <timur@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080630132426.a89c32b0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: [PATCH] fsl-diu-fb: Update Freescale DIU driver to use page_alloc_exact()
Date: Fri, 4 Jul 2008 06:32:05 -0400
References: <1214325853-26150-1-git-send-email-timur@freescale.com> <20080630132426.a89c32b0.akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 30, 2008, at 4:24 PM, Andrew Morton wrote:

> This is also incorrect.  We cannot pass u64 or uint64_t into printk at
> all.  We do not know what type the architectures uses to implement
> them.  It should be cast to a known type.  In this case `unsigned long
> long'.

Ok, I'll fix these, but I'm on vacation now and won't get to it for  
another 10 days.

