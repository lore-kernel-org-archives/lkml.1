Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYGWVxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYGWVxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYGWVxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:53:39 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:2187 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYGWVxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:53:38 -0400
Message-ID: <4887A860.6070607@gmx.de>
Date: Wed, 23 Jul 2008 23:53:36 +0200
From: Dieter Ries <clip3@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080617)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org, jgarzik@pobox.com, netdev@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, jeffrey.t.kirsher@intel.com,
       e1000-devel@lists.sourceforge.net
Subject: Re: Current Git: BUG: unable to handle kernel paging request at 0000000001a40ca0
References: <488750AA.20707@gmx.de> <19f34abd0807231046o4b194409w7d0e28a7cd745afa@mail.gmail.com> <48877200.9040608@gmx.de>
In-Reply-To: <48877200.9040608@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2008 21:53:37.0253 (UTC) FILETIME=[8F7A2150:01C8ED0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dieter Ries schrieb:
> Vegard Nossum schrieb:
>> Hi,
> 
Hi

>> Dieter: If this is reproducible, it would probably help quite a bit to
>> configure the kernel with CONFIG_SLUB_DEBUG and boot with
>> slub_debug=FZPUT (unless you already have CONFIG_SLUB_DEBUG_ON set, in
>> which case you are already running with the SLUB debugging at boot).
>> It might catch the corruption before it becomes fatal, or give us some
>> more clues anyway.

I tried to bisect the bug, which failed because there were too many 
kernels not booting with other problems, I guess bisecting just fails in 
the merge window.

With CONFIG_SLUB_DEBUG_ON the output looks different, unfortunately 
netconsole stops before those are transmitted.

As there are always some lines about e1000 in the backtraces, I tried to 
boot without LAN cable connected, and it worked, and crashed afterwards 
when I plugged the cable in, with a bug in net/core/dev.c.

I will search on tomorrow, as it is getting quite late now.

Should I copy the messages with CONFIG_SLUB_DEBUG_ON by hand, or are 
just some parts important?

cu
Dieter
