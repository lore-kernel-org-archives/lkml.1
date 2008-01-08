Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYAHFls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYAHFls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYAHFlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:41:40 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:41107 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYAHFlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:41:39 -0500
Date: Tue, 8 Jan 2008 11:11:05 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixer <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org
Subject: Re: [PATCH] i386: handle an initrd in highmem (version 2)
Message-ID: <20080108054105.GC5393@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200801080502.m0852rhW017142@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801080502.m0852rhW017142@tazenda.hos.anvin.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 09:02:53PM -0800, H. Peter Anvin wrote:
> The boot protocol has until now required that the initrd be located in
> lowmem, which makes the lowmem/highmem boundary visible to the boot
> loader.  This was exported to the bootloader via a compile-time
> field.  Unfortunately, the vmalloc= command-line option breaks this
> part of the protocol; instead of adding yet another hack that affects
> the bootloader, have the kernel relocate the initrd down below the
> lowmem boundary inside the kernel itself.
> 
> Note that this does not rely on HIGHMEM being enabled in the kernel.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
> Fix crash on NUMA reported by Dhaval Giani (reported as being a kexec issue.)
> 

Yep, it does that. Just tested that on top of the x86 git tree (the mm
queue). It boots.

Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

-- 
regards,
Dhaval
