Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXKLOyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXKLOyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXKLOy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:54:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXKLOy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:54:26 -0500
Message-ID: <47386907.5080101@redhat.com>
Date: Mon, 12 Nov 2007 15:53:59 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Amit Shah <amit.shah@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] KVM: PVDMA Guest: Guest-side routines
 for paravirtualized DMA
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>	<609d5d611a5fb58ab5a7184be7b6d29494023ba0.1194445109.git.amit.shah@qumranet.com> <20071112105001.GF3299@rhun.haifa.ibm.com>
In-Reply-To: <20071112105001.GF3299@rhun.haifa.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> On Wed, Nov 07, 2007 at 04:21:04PM +0200, Amit Shah wrote:
> 
>> We make the dma_mapping_ops structure to point to our structure so
>> that every DMA access goes through us. (This is the reason this only
>> works for 64-bit guest. 32-bit guest doesn't yet have a dma_ops
>> struct.)
> 
> I need the same facility for Calgary for falling back to swiotlb if a
> translation is disabled on some slot, and IB needs the same facility
> for some IB adapters (e.g., ipath). Perhaps it's time to consider
> stackable dma-ops (unless someone has a better idea...).

Hmm, at least the later sounds like for per-device dma_ops would be more
useful that stackable ones, as each stack instance just checks "should I
do something for device $foo, if not, call the next one ...".

cheers,
  Gerd

