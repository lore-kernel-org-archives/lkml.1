Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbXGODUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbXGODUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 23:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXGODT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 23:19:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXGODT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 23:19:57 -0400
Message-ID: <46999253.6020004@zytor.com>
Date: Sat, 14 Jul 2007 20:19:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: olaf@aepfle.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
References: <787b0d920707141948t71b4059s7ae68610f9f81eac@mail.gmail.com>
In-Reply-To: <787b0d920707141948t71b4059s7ae68610f9f81eac@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
> 
> A real constant-value PAGE_SIZE is useful and doable.
> 
> It's useful because a getpagesize() can't be used for numerous
> things, such as setting the size of an array.
> 
> It's doable, even on architectures that support multiple page
> sizes, because ABIs specify alignment requirements. There are
> two alignments of interest here:
> 
> a. the smallest that mmap() will ever naturally return on any
>   correct implementation of the architecture's ABI ("naturally"
>   meaning that MAP_FIXED was not used)
> 
> b. the smallest that mprotect() will tolerate on all
>   correct implementations of the architecture
> 
> Pick either to be the Linux definition of PAGE_SIZE.
> 

If you specify it to be one of these, people will mis-use it for the
other.  This is a bad idea.

	-hpa
