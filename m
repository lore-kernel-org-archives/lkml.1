Return-Path: <linux-kernel-owner+w=401wt.eu-S1764279AbXK3DCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764279AbXK3DCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763916AbXK3DCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:02:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762768AbXK3DCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:02:04 -0500
Message-ID: <474F7D05.9020109@zytor.com>
Date: Thu, 29 Nov 2007 19:01:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <20071129175440.ead82de6.akpm@linux-foundation.org>
In-Reply-To: <20071129175440.ead82de6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> NOTE: This patch uses a bc(1) script to compute the appropriate
>> constants.
> 
> Does this add the first dependency upon the availability of bc?

I believe it does.  I used bc because doing it C would have required 
arbitrary-precision code or have added a dependency on libgmp.

	-hpa
