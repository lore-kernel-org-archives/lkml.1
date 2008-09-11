Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYIKVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYIKVJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYIKVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:09:10 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54313 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbYIKVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:09:09 -0400
Date: Thu, 11 Sep 2008 17:09:08 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harun Scheutzow <harun04@scheutzow.de>, linux-kernel@vger.kernel.org
Subject: Re: vfat file system extreme fragmentation on multiprocessor
Message-ID: <20080911210908.GC31271@csclub.uwaterloo.ca>
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de> <20080911191049.GB31271@csclub.uwaterloo.ca> <48C97338.5080502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C97338.5080502@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 12:36:24PM -0700, H. Peter Anvin wrote:
> Lennart Sorensen wrote:
> >
> >I don't think fat filesystems have any concept of reserving space for
> >expanding files.  It's a pretty simple filesystem after all designed for
> >a single cpu machine with a non-multitasking OS (if you can call DOS an
> >OS).  Space tends to be allocated from the start of the disk wherever
> >free space is found since otherwise you would have to go searching for
> >the free space, which isn't that efficient.
> >
> 
> Well, you can always do that in-memory.

It still involves searching no matter where you do it.  With FAT-16 that
means up to 2^16 clusters to search through.  With FAT-32 even more.  It
doesn't have a cluster bitmap to speed things up.

-- 
Len Sorensen
