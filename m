Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYLSCsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYLSCsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 21:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYLSCsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 21:48:25 -0500
Received: from sh.osrg.net ([192.16.179.4]:36749 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYLSCsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 21:48:25 -0500
Date: Fri, 19 Dec 2008 11:47:42 +0900
To: beckyb@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com,
       joerg.roedel@amd.com, benh@kernel.crashing.org
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
 of swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org>
References: <4949296F.7000701@goop.org>
	<20081218015705Z.fujita.tomonori@lab.ntt.co.jp>
	<E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081219114808C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 12:17:54 -0600
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> > Can you be more specific? What architecture is plan to use highmem
> > support in swiotlb?
> 
> 32-bit powerpc needs this support - I was actually about to push a  
> similar set of patches.  We have several processors that support 36  
> bits of physical address space and do not have any iommu capability.   
> The rest of the kernel support for those processors is now in place,  
> so swiotlb is the last piece of the puzzle for that to be fully  
> functional.  I need to take a closer look at this series to see  
> exactly what it's doing and how it differs from what I've been testing.

Ah, thanks,

Then I accept that highmem support in lib/swiotbl.c is generically
useful and we have to live with the ugly complication due to it.
