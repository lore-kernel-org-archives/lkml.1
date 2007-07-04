Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbXGDJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbXGDJPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbXGDJPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:15:09 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:34257 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbXGDJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:15:08 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Re: [linux-kernel]Why there are so many struct rw_semaphore being defined?
Date: Wed, 4 Jul 2007 11:15:06 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <4104961b0707040207r7fd9054bvfd33830827102acf@mail.gmail.com>
In-Reply-To: <4104961b0707040207r7fd9054bvfd33830827102acf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041115.06233.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2007 schrieb jidong xiao:
> I see struct rw_semaphore is defined in
> include/linux/rwsem-spinlock.h,in the meanwhile, I also can find it in

Quote:

#ifndef _LINUX_RWSEM_H
#error "please don't include linux/rwsem-spinlock.h directly, use linux/rwsem.h instead"
#endif

> include/asm-**/rwsem.h,for
> example,include/asm-i386/rwsem.h,include/asm-x86_64/rwsem.h,why?which
> one should be used?

This structure is so important to performance that some architectures
have version optimized to their features.

	Regards
		Oliver
