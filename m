Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYCOUWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYCOUWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 16:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYCOUWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 16:22:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYCOUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 16:22:06 -0400
Message-ID: <47DC2F08.9080004@zytor.com>
Date: Sat, 15 Mar 2008 21:18:16 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: K8, EFFICEON and CORE2 support the cmovxx instructions.
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314195520.GV2522@one.firstfloor.org> <1205530409.27413.1242484373@webmail.messagingengine.com> <20080315191946.GA21817@mailshack.com>
In-Reply-To: <20080315191946.GA21817@mailshack.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> K8, EFFICEON and CORE2 support the cmovxx instructions.
> 
> Instead of listing the cpu's that have support for the
> cmovxx instructions, list the cpu's that don't.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> ---
> 
> A bit of playing resulted in:
> 
> CPUS="M386 M486 M586 M586TSC M586MMX M686 MPENTIUMII MPENTIUMIII"
> CPUS=$CPUS" MPENTIUMM MPENTIUM4 MK6 MK7 MK8 MCRUSOE MEFFICEON"
> CPUS=$CPUS" MWINCHIPC6 MWINCHIP2 MWINCHIP3D MGEODEGX1 MGEODE_LX"
> CPUS=$CPUS" MCYRIXIII MVIAC3_2 MVIAC7 MPSC MCORE2"
> 
> for cpu in $CPUS
> do
>         echo "CONFIG_${cpu}=y" > testconfig
>         make ARCH=i386 allnoconfig KCONFIG_ALLCONFIG=testconfig > /dev/null
>         echo ${cpu} >> result
>         grep X86_CMOV .config >> result
>         echo >> result
> done
> 
> I'm quite sure that K8, EFFICEON and CORE2 support HAVE_CMOV, but
> they did not set X86_CMOV.
> 

Crusoe has CMOV as well.

	-hpa
