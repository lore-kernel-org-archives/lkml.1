Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbXGWPTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbXGWPTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXGWPTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:19:32 -0400
Received: from outbound-mail-43.bluehost.com ([69.89.18.12]:45984 "HELO
	outbound-mail-43.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750727AbXGWPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:19:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: MTRR Patch still applies to 2.6.22-rc7.
Date: Mon, 23 Jul 2007 08:19:29 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0707030659380.21706@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0707030659380.21706@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230819.29246.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 3, 2007 4:00:07 am Justin Piszcz wrote:
> Incase anyone is interested:
>
> p34:/usr/src/linux-2.6.22-rc7# patch -p1 < ../mtrr-v3.patch
> patching file Documentation/kernel-parameters.txt
> Hunk #1 succeeded at 548 (offset -5 lines).
> patching file arch/i386/kernel/cpu/mtrr/generic.c
> Hunk #2 succeeded at 85 (offset 1 line).
> patching file arch/i386/kernel/cpu/mtrr/if.c
> patching file arch/i386/kernel/cpu/mtrr/main.c
> patching file arch/i386/kernel/cpu/mtrr/mtrr.h
> patching file arch/x86_64/kernel/bugs.c
> patching file arch/x86_64/kernel/setup.c
> patching file include/asm-x86_64/mtrr.h
> p34:/usr/src/linux-2.6.22-rc7#

Just a quick update on this Justin (thanks again for testing).  This patch 
*was* scheduled for 2.6.23 and it almost snuck upstream via Andi's tree, but 
his testing uncovered a problem at the last minute on certain AMD machines, 
so I'll have to track down that bug before we can push it.

Thanks,
Jesse
