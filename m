Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZLAJX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZLAJX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZLAJX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:23:58 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:46102 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZLAJX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:23:58 -0500
Message-ID: <4B14E08B.3010504@collabora.co.uk>
Date: Tue, 01 Dec 2009 09:23:23 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient drivers
References: <1259177252.2858.17.camel@calx> <4B139E3D.1020905@collabora.co.uk> <1259606656.29740.48.camel@calx> <200912011338.15763.rusty@rustcorp.com.au>
In-Reply-To: <200912011338.15763.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:

> But we're bikeshedding, so apply or revert.
> 
> 	/* A buffer which can hold any fundamental type: drivers are fussy. */
> 	static u8 rng_buffer[SMP_CACHE_BYTES < 8 ? 8 : SMP_CACHE_BYTES]
> 		__cacheline_aligned;

One nit - theres one driver where <24 bytes will be quite suboptimal.
I'd say pick 32 bytes, which is a common cachline size, too.

> Either way, both patches: Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!

-Ian
