Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753423AbYLRUKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYLRUKg (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYLRUKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:10:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbYLRUKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:10:24 -0500
Date: Thu, 18 Dec 2008 12:09:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bluebird@gentoo.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
In-Reply-To: <1229564779.6481.26.camel@brick>
Message-ID: <alpine.LFD.2.00.0812181208070.14014@localhost.localdomain>
References: <4943DAD6.7070402@gentoo.org>  <20081216.011334.124918024.davem@davemloft.net> <1229564779.6481.26.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Dec 2008, Harvey Harrison wrote:
>
> glibc headers define both __LITTLE_ENDIAN and __BIG_ENDIAN
> which was tripping the check in linux/byteorder.h.  Let's
> just stay out of userspace's way and use __KERN_{endian}

Gaah, ugly.

I think it would be better to just make it a config option, call it 
CONFIG_[LITTLE|BIG]_ENDIAN and set it up in the architecture Kconfig file. 
I think some of the people who can set it dynamically (or where it depends 
on the target machine) already effectively do that.

Hmm?

		Linus
