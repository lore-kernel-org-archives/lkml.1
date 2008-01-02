Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYABC0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYABC0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYABC0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:26:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYABC0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:26:36 -0500
Message-ID: <477AF560.1000002@zytor.com>
Date: Tue, 01 Jan 2008 18:22:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, mingo@redhat.com, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/byteorder.h: clean up for userspace
References: <200712311312.46450.vapier@gentoo.org> <20080101174708.GA25089@infradead.org> <477AAE6E.8080305@zytor.com> <20080102013126.GN27566@does.not.exist>
In-Reply-To: <20080102013126.GN27566@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> Userspace either has to #define CONFIG_X86_BSWAP or it'll get the slow 
> versions of these functions...
> 
> Leaking CONFIG_ variables to userspace is not really funny - I remember 
> e.g. what tricks MySQL does (did?) for (ab)using asm-i386/atomic.h in 
> userspace.
> 

True.  CONFIG_X86_BSWAP isn't appropriate for userspace anyway, 
userspace needs to use the appropriate gcc intrinsics for 486+.

	-hpa
