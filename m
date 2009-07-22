Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZGVWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZGVWeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZGVWeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:34:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60664 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbZGVWeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:34:17 -0400
To: Dave Jones <davej@redhat.com>
Cc: Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
From: Andi Kleen <andi@firstfloor.org>
References: <200907221926.50397.pavel@pavlinux.ru>
	<20090722213746.GA20241@redhat.com>
Date: Thu, 23 Jul 2009 00:34:14 +0200
In-Reply-To: <20090722213746.GA20241@redhat.com> (Dave Jones's message of "Wed, 22 Jul 2009 17:37:46 -0400")
Message-ID: <87d47s2vq1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Wed, Jul 22, 2009 at 07:26:49PM +0400, Pavel Vasilyev wrote:
>  > In the kernel configuration, if I choose x86_64 and PCI, then choose the item
>  > "Garth IOMMU support", which, in turn, chooses not to switch off, support for
>  > AGP. But many IOMMU system does not have AGP bus.
>  
> The lack of AGP slots doesn't mean a lack of AGP bus.
> It's part of the K8 on-CPU northbridge.

Right. 

One thing that could be done today is to remove the "if EMBEDDED" for
GART_IOMMU though. I don't think it's still deserved, as long as
SWIOTLB is enabled.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
