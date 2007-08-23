Return-Path: <linux-kernel-owner+w=401wt.eu-S1764125AbXHWOuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764125AbXHWOuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761994AbXHWOt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:49:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43427 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761890AbXHWOtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:49:55 -0400
Date: Thu, 23 Aug 2007 15:49:53 +0100
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-rc3-mm1 kernel BUG at mm/page_alloc.c:2876!
Message-ID: <20070823144953.GA30504@skynet.ie>
References: <46CC9A7A.2030404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <46CC9A7A.2030404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/08/07 01:50), Kamalesh Babulal didst pronounce:
> Hi Andrew,
> 
> I see call trace followed by the kernel bug with the 2.6.23-rc3-mm1
> kernel and have attached the boot log and config file.
> 

For this one in the boot log;

Built 2 zonelists in Node order, mobility grouping off.  Total pages: 0

The lack of pages might explain allocation failures :/ . Not super-clear
why it failed to find any memory yet.

-- 
Mel Gorman
