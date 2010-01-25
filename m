Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710Ab0AYOdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0AYOdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974Ab0AYOdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:33:36 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23610 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0AYOdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:33:36 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zzab9bh98dN936eM62a3Lzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWT4EF-01-53Y-02
X-M-MSG: 
Date: Mon, 25 Jan 2010 15:32:24 +0100
From: Robert Richter <robert.richter@amd.com>
To: John Villalovos <sodarock@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, oprofile-list@lists.sf.net
Subject: Re: [PATCH] Add Xeon 7500 series support to oprofile
Message-ID: <20100125143224.GH2014@erda.amd.com>
References: <20100121222627.GA22897@basil.fritz.box>
 <5e61b72f1001220823i364a7a40l21a46e0f127341fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5e61b72f1001220823i364a7a40l21a46e0f127341fb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Jan 2010 14:32:25.0391 (UTC) FILETIME=[36A0CBF0:01CA9DCB]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.01.10 11:23:08, John Villalovos wrote:
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index cb88b1a..edc074c 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -598,7 +598,7 @@ static int __init ppro_init(char **cpu_type)
>  	case 15: case 23:
>  		*cpu_type = "i386/core_2";
>  		break;
> -	case 26:
> +	case 26: case 46:

Hex values fit better here since the spec is using bit values
too. Instead, the code should be changed to only use hex values for
models with extended model bits set.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

