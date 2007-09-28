Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbXI1IgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbXI1IgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXI1IgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:36:18 -0400
Received: from SOKENS04e.snapon.com ([217.33.151.229]:56970 "EHLO
	sokens04.snapon.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754675AbXI1IgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:36:17 -0400
Message-ID: <013301c801aa$782025e0$7502a8c0@snaponglobal.com>
From: "Marco Tralli" <marco.tralli@snapon.com>
To: "Juergen Beisert" <juergen127@kreuzholzen.de>,
       <linux-kernel@vger.kernel.org>
Cc: "Jordan Crouse" <jordan.crouse@amd.com>
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com> <200709271813.26103.juergen127@kreuzholzen.de>
Subject: Re: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Fri, 28 Sep 2007 10:35:02 +0200
Organization: SNAPON
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1807
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
X-OriginalArrivalTime: 28 Sep 2007 08:36:14.0668 (UTC) FILETIME=[A18FC0C0:01C801AA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
> ===================================================================
> --- linux-2.6.22.orig/arch/i386/kernel/cpu/cyrix.c
> +++ linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
> @@ -169,7 +169,7 @@ static void __cpuinit set_cx86_inc(void)
>   setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
>   /* PCR0 -- Performance Control */
>   /* Incrementor Margin 10 */
> - setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
> + setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x05); /* 300MHz CPU */
>   setCx86(CX86_CCR3, ccr3); /* disable MAPEN */
>  }
>  
> This should be done at runtime in relation to the real CPU clock.
> 
> Hope it helps
> Juergen
>

Your patch fix my issue
Thank you

Marco



 
