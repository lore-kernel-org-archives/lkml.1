Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753463AbYLRUr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYLRUr4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYLRUro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:47:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYLRUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:47:43 -0500
Date: Thu, 18 Dec 2008 12:47:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bluebird@gentoo.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
In-Reply-To: <alpine.LFD.2.00.0812181208070.14014@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812181246420.14014@localhost.localdomain>
References: <4943DAD6.7070402@gentoo.org>  <20081216.011334.124918024.davem@davemloft.net> <1229564779.6481.26.camel@brick> <alpine.LFD.2.00.0812181208070.14014@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Dec 2008, Linus Torvalds wrote:
> 
> I think it would be better to just make it a config option, call it 
> CONFIG_[LITTLE|BIG]_ENDIAN and set it up in the architecture Kconfig file. 
> I think some of the people who can set it dynamically (or where it depends 
> on the target machine) already effectively do that.

Never mind, since we end up having to export it to user space (do we?) we 
can't depend on the config.h file, nor can we pollute the name space.

Oh well.

		Linus
