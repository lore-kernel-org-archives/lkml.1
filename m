Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbXLaFzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbXLaFzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 00:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXLaFzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 00:55:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbXLaFzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 00:55:38 -0500
Message-ID: <47788358.5090409@zytor.com>
Date: Sun, 30 Dec 2007 21:51:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: tglx@linutronix.de, mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
References: <200712310045.24069.vapier@gentoo.org>
In-Reply-To: <200712310045.24069.vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> The current asm-x86/msr.h does not actually define anything for (!__KERNEL__
> && __i386__).  For x86_64, it fails to build due to u32/u64 types being used.
> Simply not installing the header seems easiest to me.  Otherwise, x86_64 will
> need sanitizing and i386 should have things added back, otherwise it's just a
> pointless empty header.
> 
> Signed-Off-By: Mike Frysinger <vapier@gentoo.org>

<asm/msr-index.h> is usable from userspace, <asm/msr.h> includes it for 
backwards compatibility.

Nothing else is wanted or needed.

	-hpa
