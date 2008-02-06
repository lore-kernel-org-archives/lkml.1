Return-Path: <linux-kernel-owner+w=401wt.eu-S932955AbYBFXWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbYBFXWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbYBFXWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:22:44 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:47282 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbYBFXWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:22:43 -0500
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tomof@acm.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: Ordering of commits and breaking bisecting
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080206093817.60091256.sfr@canb.auug.org.au>
References: <20080206093817.60091256.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080207082227O.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 07 Feb 2008 08:22:27 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 09:38:17 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Can we be a bit more careful with the ordering of commits, please?
> Commit d22a6966b8029913fac37d078ab2403898d94c63 (iommu sg merging: add
> accessors for segment_boundary_mask in device_dma_parameters())
> introduces the dma_get_seg_boundary accessor which is used in the
> *preceding* commits fb3475e9b6bfa666107512fbd6006c26014f04b8 (for
> powerpc), and 1b39b077789955c8389488d53d075518fdcd582e and
> fde9a1094ddf2892188a8a0eccda527de47cba8e (for x86).
> 
> Thus we have another set of commits that will break bisection.  This one
> was easily avoidable.
> 
> A little more care is needed.

Sorry about it.

I submitted the patches in the proper order but the order seemed to be
reversed in the -mm.

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html

I could have noticed the issue since it has been in the -mm for a long
time, sorry.
