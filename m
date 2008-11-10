Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYKJV6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYKJV6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYKJV6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:58:15 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:55868 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYKJV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:58:14 -0500
Date: Mon, 10 Nov 2008 15:57:40 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Robin Holt <holt@sgi.com>
cc: Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-ia64@vger.kernel.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
In-Reply-To: <20081110190711.GG8483@sgi.com>
Message-ID: <Pine.LNX.4.64.0811101555380.32105@quilx.com>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com> <87d4h3pwhe.fsf@basil.nowhere.org>
 <20081110190711.GG8483@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Robin Holt wrote:

> I am not sure what is be referred to here, but all of an Altix's memory is
> DMA capable with the exception of the stuff covered by the MSPEC driver
> (that is uncached memory).  There are certainly all sort of special
> requirements for doing transfers on Altix to eliminate memory ordering
> problems, but nothing specific that I recall related to address ranges
> and DMA.

But then ZONE_DMA has nothing to do with memory being dmaable or not.
ZONE_DMA is for legacy devices that cannot do DMA to all of memory.
I vaguely remember having stuffed all the memory into ZONE_NORMAL at some
point. ZONE_DMA vanishes for Altix configurations.

