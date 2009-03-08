Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZCHVGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZCHVGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZCHVFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:05:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbZCHVFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:05:53 -0400
Message-ID: <49B4330C.1060700@zytor.com>
Date: Sun, 08 Mar 2009 14:05:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org> <20090308110437.GA27811@elte.hu> <20090308145803.GL25995@parisc-linux.org>
In-Reply-To: <20090308145803.GL25995@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Mar 08, 2009 at 12:04:37PM +0100, Ingo Molnar wrote:
>> I'd also suggest to flip around the subject line from x86/pci to 
>> pci/x86 - it's more of a PCI patch than a pure x86 patch. The 
>> same problem could affect other platforms too i suspect.
> 
> Not all platforms expose the root bridge in PCI configuration space.
> Intel ia64 platforms do have a materialised root bridge; HP's don't.
> (I don't know whether Intel ship any PCIe ia64 machines or not).  I
> don't remember details for other platforms, but I think Intel is the odd
> one out in this regard.
> 

It's still generic PCI code, however.  If there is no host bridge
exposed in PCI space, the patch is a noop.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

