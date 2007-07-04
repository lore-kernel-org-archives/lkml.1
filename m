Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbXGDKe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbXGDKe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760970AbXGDKeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:34:36 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50590 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXGDKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:34:35 -0400
Message-ID: <468B77A8.9020504@s5r6.in-berlin.de>
Date: Wed, 04 Jul 2007 12:34:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: jidong xiao <jidong.xiao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [linux-kernel]Why there are so many struct rw_semaphore being
 defined?
References: <4104961b0707040207r7fd9054bvfd33830827102acf@mail.gmail.com> <200707041115.06233.oliver@neukum.org>
In-Reply-To: <200707041115.06233.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 4. Juli 2007 schrieb jidong xiao:
>> I see struct rw_semaphore is defined in
>> include/linux/rwsem-spinlock.h,in the meanwhile, I also can find it in
> 
> Quote:
> 
> #ifndef _LINUX_RWSEM_H
> #error "please don't include linux/rwsem-spinlock.h directly, use linux/rwsem.h instead"
> #endif
> 
>> include/asm-**/rwsem.h,for
>> example,include/asm-i386/rwsem.h,include/asm-x86_64/rwsem.h,why?which
>> one should be used?
> 
> This structure is so important to performance that some architectures
> have version optimized to their features.

...but of course we generally include linux/rwsem.h instead of
architecture-specific header files.  linux/rwsem.h will transparently
pull in the optimized variants for us.  (It's evident from the source.)
-- 
Stefan Richter
-=====-=-=== -=== --=--
http://arcgraph.de/sr/
