Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXLBBx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXLBBx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 20:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXLBBxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 20:53:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXLBBxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 20:53:50 -0500
Message-ID: <47521010.7050309@zytor.com>
Date: Sat, 01 Dec 2007 17:53:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>	<20071201003333.GR29463@stusta.de> <20071201132047.2bf3c40c@the-village.bc.nu>
In-Reply-To: <20071201132047.2bf3c40c@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> Its visibile for people doing PAL media processing and TV sync work.
> 
> Longer term we have high precision timers and tickless so for now we can
> jut do the HZ == 300 math in steps to avoid the overflow. Slower but in
> time it won't matter.
> 

Just use the patch... I don't think a dependency on bc will be a problem 
for anyone (but it should, indeed, be documented -- together with 
everything else we haven't documented yet.)

	-hpa
