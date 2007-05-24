Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXEXXqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXEXXqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXEXXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:46:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49261 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbXEXXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:46:24 -0400
Date: Fri, 25 May 2007 00:50:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in
 /proc/cpuinfo
Message-ID: <20070525005025.236d2483@the-village.bc.nu>
In-Reply-To: <20070524224154.GA29337@redhat.com>
References: <20070523224637.GB15887@linux-os.sc.intel.com>
	<20070524150223.41063046.akpm@linux-foundation.org>
	<46560E4F.2080009@zytor.com>
	<20070524224154.GA29337@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 18:41:54 -0400
Dave Jones <davej@redhat.com> wrote:

> On Thu, May 24, 2007 at 03:14:39PM -0700, H. Peter Anvin wrote:
> 
>  > pbe collides with abuse by at least two vendors (AMD and
>  > Cyrix/Centaur/VIA) of this bit for 3DNow.
> 
> Unless I'm mistaken,
> 
> pbe comes from cpuid level 1
> 
> 3dnow comes from cpuid level 0x80000001
> though I did notice that amd have it in edx, whilst via have it in ecx
> curiously.

The older AMD docs (CPU rev guide) list bit 31 of both 0x80000001 and
0x00000001 as 3dnow

All their example code/docs say to use 0x80000001 

