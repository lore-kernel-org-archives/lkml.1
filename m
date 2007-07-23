Return-Path: <linux-kernel-owner+w=401wt.eu-S1763056AbXGWRVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763056AbXGWRVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbXGWRVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:21:16 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45438 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbXGWRVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:21:16 -0400
X-IronPort-AV: i="4.16,571,1175486400"; 
   d="scan'208"; a="35493273:sNHT24592911"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: blackfin - cmpxchg not atomic ?
Date: Mon, 23 Jul 2007 13:24:52 -0400
User-Agent: KMail/1.9.5
Cc: tonyko@lineo.ca, linux-kernel@vger.kernel.org
References: <20070720202807.GA15009@Krystal>
In-Reply-To: <20070720202807.GA15009@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231324.53105.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 23 Jul 2007 17:21:13.0172 (UTC) FILETIME=[DE74C940:01C7CD4D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20 Jul 2007 16:28, Mathieu Desnoyers pondered:
>
> I also don't like the comment in asm-blackfin/atomic.h :
> 
>  * Generally we do not concern about SMP BFIN systems, so we don't have
>  * to deal with that.
> 
> I have seen on the blackfin website that you actually sell a board with
> SMP. Why aren't you caring about it ?

Just because something is dual core - doesn't mean it is capable of true SMP.

The 2 blackfin cores on the BF561 have their own L1 cache, but the caches are 
not coherent to the internal L2 (which is not cache, but just memory), or 
external L3.

This precludes SMP where common memory must be addressed by both cores.

-Robin
