Return-Path: <linux-kernel-owner+w=401wt.eu-S1761876AbXFTH5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876AbXFTH5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbXFTH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:57:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:42946 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794AbXFTH52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:57:28 -0400
Message-ID: <4678DB8C.4040200@qumranet.com>
Date: Wed, 20 Jun 2007 10:47:24 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: Fix x86 emulator writeback
References: <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan> <4675523C.9020703@qumranet.com> <20070617165201.GA23885@dreamland.darkstar.lan> <46765954.60102@qumranet.com> <46766D57.8040206@qumranet.com> <20070619202524.GA17672@dreamland.darkstar.lan> <20070619204120.GA18800@dreamland.darkstar.lan>
In-Reply-To: <20070619204120.GA18800@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 20 Jun 2007 10:47:24 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> When the old value and new one are the same the emulator skips the
> write; this is undesiderable when the destination is a MMIO area and the
> write shall be performed regardless of the previous value. This
> optimization breaks e.g. a Linux guest APIC compiled without
> X86_GOOD_APIC.
>
> Remove the check and perform the writeback stage in the emulation unless
> it's explicitly disabled (currently push and some 2 bytes instructions
> may disable the writeback).
>
>   

Applied both, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

