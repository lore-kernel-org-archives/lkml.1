Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZC0GnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZC0GnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 02:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZC0GnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 02:43:09 -0400
Received: from kuber.nabble.com ([216.139.236.158]:35008 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZC0GnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 02:43:08 -0400
Message-ID: <22736728.post@talk.nabble.com>
Date: Thu, 26 Mar 2009 23:43:03 -0700 (PDT)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Copy-on-write
In-Reply-To: <3e8340490903262235g6174c6b4t4bfd76311be91eeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <22736146.post@talk.nabble.com> <3e8340490903262235g6174c6b4t4bfd76311be91eeb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If the source and destination pages are not in high memory (exactly
> where this boundary is depends on your architecture) they do not need
> to be mapped before copying. See cow_user_page in mm/memory.c,
> copy_user_highpage in include/linux/highmem.h and kmap_atomic in
> arch/x86/mm/highmem_32.c (as well as implementations for other
> architectures)

> Note that on 64-bit platforms, generally there will be no high memory,
> and so remappings will never be needed to carry out a COW.

Thanks for the quick reply. In general if the kernel wishes to read any
arbitrary page mapped to an application's address space, will the kernel
cause a page fault on that page, since the page is currently not in its
address space and the kernel is wishing to read from this page?

Thanks

-- 
View this message in context: http://www.nabble.com/Copy-on-write-tp22736146p22736728.html
Sent from the linux-kernel mailing list archive at Nabble.com.

