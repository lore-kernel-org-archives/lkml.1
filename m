Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbYEON7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbYEON7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYEON7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:59:04 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45457 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283AbYEON7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:59:03 -0400
Date: Thu, 15 May 2008 09:59:01 -0400
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to avoid data copies in a driver ?
Message-ID: <20080515135901.GX7577@csclub.uwaterloo.ca>
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com> <20080514200250.GB7579@csclub.uwaterloo.ca> <38b2ab8a0805150044q3f336d64v20dd5ac78a2c1af2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0805150044q3f336d64v20dd5ac78a2c1af2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:44:37AM +0200, Francis Moreau wrote:
> So I would need to map this pointer into the kernel space, then fill it, take
> care of cache coherency, unmap the kernel pointer.
> 
> Do you have any example of that in the kernel tree ?

I was asking if that would work.  Does the to_user and from_user work on
a pointer from user space if that pointer points at a memory mapped
file?

> BTW, data are received in interrupt context. Is it safe to put them in mapped
> memory  (can I have page fault ?) in this context ?

Oh I thought you just wanted user space to be able to ask for a chunk of
data.  I wouldn't want to write to a file in an interrupt handler.
Compared to the disk I/O a memory copy sounds rather insignificant to
the overall process.

-- 
Len Sorensen
