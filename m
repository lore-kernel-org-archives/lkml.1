Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXFQQ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXFQQ6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbXFQQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:58:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:51204 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbXFQQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:58:41 -0400
Message-ID: <46756839.50200@qumranet.com>
Date: Sun, 17 Jun 2007 19:58:33 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: Fix x86 emulator writeback
References: <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan> <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan> <4675523C.9020703@qumranet.com> <20070617165201.GA23885@dreamland.darkstar.lan>
In-Reply-To: <20070617165201.GA23885@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> When the old value and new one are the same the emulator skips the
> write; this is undesiderable when the destination is a MMIO area and the
> write shall be performed regardless of the previous value. This
> optimization breaks e.g. a Linux guest APIC compiled without
> X86_GOOD_APIC.
>
> Remove the check and always perform the writeback stage in the
> emulation.
>
>   

Applied this and the next patch.  Thanks!

-- 
error compiling committee.c: too many arguments to function

