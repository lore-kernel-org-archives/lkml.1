Return-Path: <linux-kernel-owner+w=401wt.eu-S1764351AbXK3DFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764351AbXK3DFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764005AbXK3DFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:05:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbXK3DFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:05:31 -0500
Message-ID: <474F7DC4.8000607@zytor.com>
Date: Thu, 29 Nov 2007 19:04:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <474F6E7A.3090705@redhat.com>
In-Reply-To: <474F6E7A.3090705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> H. Peter Anvin wrote:
>> NOTE: This patch uses a bc(1) script to compute the appropriate
>> constants.
> 
> Perhaps dc would be more appropriate?  That's included in busybox.
> 

Perhaps it would, but I think there is more variability between dc 
implementations -- consider if the busybox version is broken, for eample.

Either way, how many people compile their kernels in a busybox environment?

Anyway, I don't think compiling bc is hard on anything which has a C 
compiler.

	-hpa
