Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYL0VKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYL0VKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 16:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYL0VKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 16:10:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57729 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbYL0VKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 16:10:20 -0500
Message-ID: <4956995B.9080000@zytor.com>
Date: Sat, 27 Dec 2008 13:08:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <200812271505.46872.vapier@gentoo.org> <495693E5.3060604@zytor.com> <200812271557.07003.vapier@gentoo.org>
In-Reply-To: <200812271557.07003.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> 
> looking at asm-generic/fcntl.h, i'd propose this change as a template:
> ...
> #ifdef __KERNEL__
> # define kernel_flock flock
> #endif
> struct kernel_flock {
> ...
> -mike

It should be __kernel_flock or something like that.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

