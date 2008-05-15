Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbYEOU4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbYEOU4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYEOU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:56:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54361 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYEOU4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:56:00 -0400
Date: Thu, 15 May 2008 23:03:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080515210340.GC318@one.firstfloor.org>
References: <87y76cym96.fsf@basil.nowhere.org> <20080515181619R.tomof@acm.org> <482C02A4.80101@firstfloor.org> <20080515184126O.tomof@acm.org> <20080515152631.GG6778@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515152631.GG6778@il.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:26:31PM +0300, Muli Ben-Yehuda wrote:
> On Thu, May 15, 2008 at 06:41:26PM +0900, FUJITA Tomonori wrote:
> 
> > I thought that KVM people want to do it per device (in the first
> > case). So with my patchse, they can replace the dma_ops pointer in
> > dev_archdata with what they want.
> 
> That's my understanding too. We use stackable ops as a poor man's
> replacement for per-device ops (depending on what kind of device it
> is, call the original ops or our pvdma ops).

But in the KVM case you still need to support the underlying ops too, e.g. in 
case of bouncing through swiotlb needed

-Andi
