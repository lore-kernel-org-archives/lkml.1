Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbXLGWXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbXLGWXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbXLGWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:22:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54726 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbXLGWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:22:57 -0500
Message-ID: <4759C7BD.5060803@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 03:52:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <200712072301.38723.arnd@arndb.de>
In-Reply-To: <200712072301.38723.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 07 December 2007, Balbir Singh wrote:
>> Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
>> NUMA nodes can be specified using the following command line option
>>
>> numa=fake=<node range>
>>
>> node range is of the format <range1>,<range2>,...<rangeN>
> 
> Excellent idea! I'd love to have this in RHEL5u1, because that would make
> that distro boot on certain machines that have more memory than is supported
> without an iommu driver. The problem we have is that when you simply
> say mem=1G but all of the first gigabyte is on the first node, you end
> up with a memoryless node, which is not supported.
> 
> Unfortunately, it comes too late for me now, as all new distros already boot
> on Cell machines that need an IOMMU.

Very interesting use case! I am sure there are others were fake NUMA
nodes can be applied. I just listed one other in another email, apart
from using it for playing around with NUMA like machines.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
