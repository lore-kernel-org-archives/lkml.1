Return-Path: <linux-kernel-owner+w=401wt.eu-S1030370AbXCSQjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370AbXCSQjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030368AbXCSQjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:39:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42777 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030299AbXCSQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:39:15 -0400
Date: Mon, 19 Mar 2007 18:39:14 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
In-Reply-To: <6bffcb0e0703190934i1c0d3e9av1300883271dcea53@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703191838220.22180@sbz-30.cs.Helsinki.FI>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net> 
 <45FD8684.4030501@googlemail.com>  <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
  <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI> 
 <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>
 <6bffcb0e0703190934i1c0d3e9av1300883271dcea53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Michal Piotrowski wrote:
> > Yes, revoke-special-mmap-handling.patch is bad.
> 
> +               if (unlikely(vma->vm_flags & VM_REVOKED))
> +                       return -ENODEV;
> 
> Why -ENODEV?

That's what we want when trying to remap a revoked mapping (the vma is 
there, but you need to unmap it before reusing the region).

			Pekka
