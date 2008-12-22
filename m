Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYLVGci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYLVGci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 01:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYLVGca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 01:32:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYLVGc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 01:32:29 -0500
Message-ID: <494F343C.1030602@zytor.com>
Date: Sun, 21 Dec 2008 22:31:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [Bug #12156] v2.6.28-rc2: x86_32 relocation regression?
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <vy-yJy0f3YP.A.yhB.qaYTJB@chimera> <20081221081406.GB4773@elte.hu>
In-Reply-To: <20081221081406.GB4773@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> not really a regression but a long-standing inconvenience/bug of the debug 
> symbols of relocatable kernels. (ever since relocatable kernels were added 
> in '06 or so.) Nevertheless we queued up a revert of the defconfig change 
> for .29, to not expose it in the defconfig:
> 
>  f269b07: x86: revert CONFIG_RELOCATABLE=y defconfig change
> 
> so i think it can be taken off the regressions list.
> 

It's a bug, yes, not a regression.  It should be fixed if possible, but
it's not a regression nor a hideously critical issue.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

