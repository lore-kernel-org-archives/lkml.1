Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbXJMILL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbXJMILL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXJMIKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:10:53 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:44763 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbXJMIKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:10:51 -0400
Message-ID: <47107D7B.7020200@cosmosbay.com>
Date: Sat, 13 Oct 2007 10:10:35 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: How to find slab\'s usage?
References: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp>	<84144f020710130043v4f8e4cfbm178c88478d4b053d@mail.gmail.com> <200710131702.FHD09857.VSQOLFtFOJHMFO@I-love.SAKURA.ne.jp>
In-Reply-To: <200710131702.FHD09857.VSQOLFtFOJHMFO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 13 Oct 2007 10:10:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa a écrit :
> Hello.
> 
> Pekka Enberg wrote:
>>> I saw /proc/meminfo and it seems to me that slab is leaking memory.
>>> But /usr/bin/slabtop claims /proc/slabinfo is missing.
>> Do you have CONFIG_SLUB enabled? Try looking into /sys/slab/.
> 
> Yes. There is /sys/slab/ .
> But are there any tools for browsing like /usr/bin/slabtop ?
> Is
>   cd /sys/slab/; for i in *; do echo -n $i " "; cat $i/slabs; done
> the only way currently available?

Grab kernel sources, you'll find inside : Documentation/vm/slabinfo.c

gcc -o slabinfo Documentation/vm/slabinfo.c

