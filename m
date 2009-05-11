Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZEKQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZEKQ6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZEKQ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:57:58 -0400
Received: from gw.goop.org ([64.81.55.164]:54088 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZEKQ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:57:57 -0400
Message-ID: <4A085915.50300@goop.org>
Date: Mon, 11 May 2009 09:57:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: swiotlb support for Xen dom0
References: <1241741842-7966-1-git-send-email-jeremy@goop.org> <20090511130455.GO13954@elte.hu>
In-Reply-To: <20090511130455.GO13954@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Hi Ingo,
>>
>> This branch adds the swiotlb hooks for Xen dom0.  We use swiotlb 
>> to handle various device drivers which assume that multipage DMA 
>> transfers which are contigious in kernel memory are also 
>> contigious in machine memory (mostly lower-performance devices, as 
>> high-performance ones already do a good job of scatter-gather).
>>
>> Following Fujita's suggestion, these changes remove a lot of the 
>> placeholder stubs in arch/x86/kernel/pci-swiotlb.c and moves them 
>> into the Xen-specific arch/x86/xen/pci-swiotlb.c.  (It still 
>> relies on overriding the weak functions defined in lib/swiotlb.c.)
>>
>> The following changes since commit 2af252ab26150b4411889c9eaf1af4c5bf03de78:
>>   Jeremy Fitzhardinge (1):
>>         xen: checkpatch cleanups
>>     
>
> Would be nice to have a pull request for this with Fujita-san's acks 
> embedded in the commits, and with a tree based against tip:x86/xen.
>   

I will regenerate the branch with the acks (and Joerg made some comments 
which I'll address too).

    J
