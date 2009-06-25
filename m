Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZFYK7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZFYK7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZFYK64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:58:56 -0400
Received: from mail.gdatech.co.in ([124.124.200.195]:37937 "EHLO
	mail.gdatech.co.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZFYK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:58:56 -0400
Message-ID: <4A436265.4050502@gdatech.co.in>
Date: Thu, 25 Jun 2009 17:11:25 +0530
From: vijay baskar <cn.vijaibaskar@gdatech.co.in>
User-Agent: Mozilla Thunderbird 1.0.7-1.4.1 (X11/20050929)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: UIO driver for framebuffer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have written a uio driver for framebuffer device. I added device 
specific register memory in uio.mem. I also added DMA param memory in 
uio.mem to perform DMA from userspace. Also video RAM 
<http://fixunix.com/#> was mapped in kernel space using 
dma_alloc_coherent() and a logical address was obtained. This logical 
address was also added in uio.mem with memtype as UIO_MEM_LOGICAL 
because i can fill video ram from userspace.Read and write to this DMA 
param memory from userspace is not having any effect. Also video RAM 
memory that i filled up is not getting written to the framebuffer device 
when DMA is started. Also one more info that i noted was that values 
assigned to logical addresses in kernel space are not reflected in 
userspace after mmap. The values in userspace show different values 
compared to that in kernel space.
This is a bit confusing for me. Why is this happening?? Have I missed 
any information?? Am i on the right path??

regards,
vijai
