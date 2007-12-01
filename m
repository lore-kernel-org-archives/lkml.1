Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbXLAEUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbXLAEUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 23:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXLAET7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 23:19:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbXLAET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 23:19:58 -0500
Message-ID: <4750E0D7.9060402@zytor.com>
Date: Fri, 30 Nov 2007 20:19:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <20071201003333.GR29463@stusta.de>
In-Reply-To: <20071201003333.GR29463@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> I have read the hep text, but are the advantages of HZ == 300 really 
> visible or was this more theoretical?
> 
> In the latter case, we might remove the HZ == 300 choice instead.
> 

Well, we have, for various architectures:

HZ == 48, 100, 128, 250, 256, 300, 1000, 1024

You'd have to kill 48, 128, 256, 300 and 1024.

	-hpa

