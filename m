Return-Path: <linux-kernel-owner+w=401wt.eu-S1765135AbYEOVp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765135AbYEOVp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYEOVpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:45:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55858 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbYEOVpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:45:14 -0400
Message-ID: <482CAEE6.5080509@firstfloor.org>
Date: Thu, 15 May 2008 23:45:10 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
References: <87y76cym96.fsf@basil.nowhere.org> <20080515181619R.tomof@acm.org> <482C02A4.80101@firstfloor.org> <20080515184126O.tomof@acm.org> <20080515152631.GG6778@il.ibm.com> <20080515210340.GC318@one.firstfloor.org> <20080515213946.GE10434@il.ibm.com>
In-Reply-To: <20080515213946.GE10434@il.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> On Thu, May 15, 2008 at 11:03:40PM +0200, Andi Kleen wrote:
>> On Thu, May 15, 2008 at 06:26:31PM +0300, Muli Ben-Yehuda wrote:
>>> On Thu, May 15, 2008 at 06:41:26PM +0900, FUJITA Tomonori wrote:
>>>
>>>> I thought that KVM people want to do it per device (in the first
>>>> case). So with my patchse, they can replace the dma_ops pointer
>>>> in dev_archdata with what they want.
>>> That's my understanding too. We use stackable ops as a poor man's
>>> replacement for per-device ops (depending on what kind of device
>>> it is, call the original ops or our pvdma ops).
>> But in the KVM case you still need to support the underlying ops
>> too, e.g. in case of bouncing through swiotlb needed
> 
> Good point, although "secondary" DMA-ops should only be needed in rare
> cases 

Even rare cases need to be handled. In the nodma bitmap case it was the
same always btw

-Andi

