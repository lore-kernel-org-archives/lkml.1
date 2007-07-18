Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbXGRROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbXGRROh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760671AbXGRRO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:14:29 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:53599 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760570AbXGRRO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:14:28 -0400
Message-ID: <469E4A70.1000306@grupopie.com>
Date: Wed, 18 Jul 2007 18:14:24 +0100
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: koan <koan00@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow Soft-RAID 5 performance
References: <64d833020707180707i1bbbbcbao783e33a2487c9e2b@mail.gmail.com>
In-Reply-To: <64d833020707180707i1bbbbcbao783e33a2487c9e2b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

koan wrote:
> How did you create the ext3 filesystem?

The chunk_size is at 256KB, ext3 block size is 4k. I believe the correct
option that should be passed trough to --stride is 64.
Am I correct ?

I've also tested ( after sending my first report ) with xfs.
I've also increases readahead to 65535 on all HD's
I've also increases the stripe_cache_size to 16384.

I can now get ~100MB/sec...

>
> Did you use the appropriate --stride option as noted here:
> http://tldp.org/HOWTO/Software-RAID-HOWTO-5.html (#5.11)
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>

