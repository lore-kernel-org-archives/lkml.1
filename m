Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103Ab0AUUNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0AUUNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384Ab0AUUNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:13:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:59287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0AUUNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:13:21 -0500
Message-ID: <4B58B515.2050809@kernel.org>
Date: Thu, 21 Jan 2010 12:12:05 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/36] x86/pci: enable pci root res read out for 32bit
 too
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org> <1264055303-15123-6-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1001210750140.13231@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001210750140.13231@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 07:54 AM, Linus Torvalds wrote:
> 
> 
> On Wed, 20 Jan 2010, Yinghai Lu wrote:
>>
>>  			printk(KERN_DEBUG "bus: %02x index %x %s: [%llx, %llx]\n",
>>  			       busnum, j,
>>  			       (res->flags & IORESOURCE_IO)?"io port":"mmio",
>> -			       res->start, res->end);
>> +			       (u64)res->start, (u64)res->end);
> 
> When fixing these kinds of things, please just make it use '%pR' instead.
> 
> A simple
> 
> 	printk(KERN_DEBUG "bus: %02x index %x %pR\n", busnum, j, res);
> 
> should do the right thing, printing the resource with nice human-readable 
> flags. Including things like 64-bit/prefetching information for memory 
> resources etc that the current manual resource printout doesn't do.

ok.

YH
