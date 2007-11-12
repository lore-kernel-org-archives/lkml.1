Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXKLIdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXKLIdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 03:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXKLIdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 03:33:32 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:19325 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbXKLIdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 03:33:31 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 03:33:31 EST
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [kvm-devel] [PATCH 0/24] paravirt_ops for unified x86 - that's me again!
Date: Mon, 12 Nov 2007 13:47:19 +0530
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, zach@vmware.com, lguest@ozlabs.org,
       ak@suse.de, avi@qumranet.com, virtualization@lists.linux-foundation.org,
       akpm@linux-foundation.org
References: <11946337851964-git-send-email-gcosta@redhat.com>
In-Reply-To: <11946337851964-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121347.20050.amit.shah@qumranet.com>
X-OriginalArrivalTime: 12 Nov 2007 08:17:16.0519 (UTC) FILETIME=[6FC2BF70:01C82504]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 November 2007 00:12:41 Glauber de Oliveira Costa wrote:
> Hey folks,
>
> Here's a new spin of the pvops64 patch series.
> We didn't get that many comments from the last time,
> so it should be probably almost ready to get in. Heya!
>
> >From the last version, the most notable changes are:
>
> * consolidation of system.h, merging jeremy's comments about ordering
>   concerns
> * consolidation of smp functions that goes through smp_ops. They're sharing
>   a bunch of code now.
>
> Other than that, just some issues that arose from the rebase.
>
> Please, not that this patch series _does not_ apply over linus git anymore,
> but rather, over tglx cleanup series.
>
> The first patch in this series is already on linus', but not on tglx', so
> I'm sending it again, because you'll need it if you want to compile it
> anyway.
>
> tglx, in the absense of any outstanding NACKs, or any very big call for
> improvements, could you please pull it in your tree?
>
> Have fun,

Glauber, are you planning on consolidating the dma_ops structure for 32- and 
64-bit? 32-bit doesn't currently have a dma_mapping_ops structure, which 
makes paravirtualizing DMA access difficult on 32-bit.
