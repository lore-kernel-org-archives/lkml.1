Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbYD0Tee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbYD0Tee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763306AbYD0TeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:34:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57792 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762239AbYD0TeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:34:07 -0400
Message-ID: <4814D420.6060007@zytor.com>
Date: Sun, 27 Apr 2008 12:29:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai.lu@sun.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, jbarnes@virtuousgeek.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git pull] "big box" x86 changes, boot protocol
References: <20080426185516.GA32364@elte.hu>	 <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>	 <20080426195407.GA13729@elte.hu> <1209295271.2063.94.camel@localhost.localdomain>
In-Reply-To: <1209295271.2063.94.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> 
> How about this. I can redo against current Linus but that will need
> fixups here.
> 
> From cfed8d4043fc03ed948518076db602919b111a16 Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ijc@hellion.org.uk>
> Date: Sun, 27 Apr 2008 12:19:11 +0100
> Subject: [PATCH] Backfill x86 boot protocol documentation.
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  Documentation/i386/boot.txt |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
> index 0fac346..86fbbd0 100644
> --- a/Documentation/i386/boot.txt
> +++ b/Documentation/i386/boot.txt
> @@ -40,9 +40,17 @@ Protocol 2.05:	(Kernel 2.6.20) Make protected mode kernel relocatable.
>  		Introduce relocatable_kernel and kernel_alignment fields.
>  
>  Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
> -		the boot command line
> +		the boot command line.
>  
> -Protocol 2.09:	(kernel 2.6.26) Added a field of 64-bit physical
> +Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised boot protocol.
> +		Introduced hardware_subarch and hardware_subarch_data
> +		and KEEP_SEGMENTS flag in load_flags.
> +
> +Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
> +		payload. Introduced payload_offset and payload length
> +		fields to aid in locating the payload.
> +
> +Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
>  		pointer to single linked list of struct	setup_data.
>  

Acked-by: H. Peter Anvin <hpa@zytor.com>

Since this is a documentation fix, it can wait until post-window.

	-hpa
