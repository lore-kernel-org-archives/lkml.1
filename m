Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZHCKOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZHCKOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZHCKOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:14:15 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:4577 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZHCKOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:14:14 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNSPRG-03-IE2-01
Date: Mon, 3 Aug 2009 12:14:01 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sachin Sant <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
Message-ID: <20090803101401.GA14442@aftab>
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au>
 <4A718338.6050907@in.ibm.com>
 <20090730135623.GB16659@aftab>
 <20090803093144.GC9074@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090803093144.GC9074@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Aug 2009 10:14:02.0413 (UTC) FILETIME=[1FD7D5D0:01CA1423]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, Aug 03, 2009 at 11:31:44AM +0200, Ingo Molnar wrote:
> Borislav, this patch:
> 
>  From 4581c6313c16a38ffcef8bccd6ffbe9598d585b0 Mon Sep 17 00:00:00 2001
>  From: Andreas Herrmann <andreas.herrmann3@amd.com>
>  Date: Fri, 24 Jul 2009 10:21:06 +0200
>  Subject: [PATCH] x86: provide CPU topology information for multi-node processors
> 
>  arch/x86/include/asm/processor.h |    2 ++
>  arch/x86/include/asm/smp.h       |    6 ++++++
>  arch/x86/include/asm/topology.h  |    2 ++
>  arch/x86/kernel/cpu/common.c     |    2 ++
>  arch/x86/kernel/cpu/proc.c       |    1 +
>  arch/x86/kernel/smpboot.c        |   20 ++++++++++++++++----
>  6 files changed, 29 insertions(+), 4 deletions(-)
> 
> has absolutely _ZERO_ place in the EDAC tree. It was submitted to 
> the x86 tree and was under discussion - i requested changes to it so 
> this current form has my NAK.

I know that, I'm following the discussion. I needed the functionality in
EDAC and that's why I added them _temporarily_ to the mix so that the
whole series (esp. the MCE bits) can see some testing. Which obviously
caught some issues :).

But I'm very well aware that the patches are not final and they will go
through x86 when done. This is what I told Stephen when upping them for
linux-next.

Sorry if I've caused any misunderstanding.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

