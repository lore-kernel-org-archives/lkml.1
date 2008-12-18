Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbYLRVZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbYLRVZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYLRVZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:25:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYLRVZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:25:05 -0500
Message-ID: <494ABDED.60308@zytor.com>
Date: Thu, 18 Dec 2008 13:17:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       npiggin@suse.de, hugh@veritas.com, arjan@infradead.org,
       jbarnes@virtuousgeek.org, rdreier@cisco.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/7] x86 PAT: track pfnmap mappings with remap_pfn_range
 vm_insert_pfn - v3
References: <20081218194126.963894000@intel.com>
In-Reply-To: <20081218194126.963894000@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com wrote:
> v3: Patches updated based on Andrew's comments on the earlier version.
> 
> Drivers use mmap followed by pgprot_* and remap_pfn_range or vm_insert_pfn,
> in order to export reserved memory to userspace. Currently, such mappings are
> not tracked and hence not kept consistent with other mappings (/dev/mem,
> pci resource, ioremap) for the sme memory, that may exist in the system.
> 
> The following patchset adds x86 PAT attribute tracking and untracking for
> pfnmap related APIs.
> 
> First three patches in the patchset are changing the generic mm code to fit
> in this tracking. Last four patches are x86 specific to make things work
> with x86 PAT code. The patchset aso introduces pgprot_writecombine interface,
> which gives writecombine mapping when enabled, falling back to
> pgprot_noncached otherwise.

Series applied to tip:x86/pat2, thanks!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

