Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXBQVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXBQVAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932894AbXBQVAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:00:25 -0500
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:59896 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932893AbXBQVAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:00:24 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [ck] Re: 2.6.20-ck1
Date: Sun, 18 Feb 2007 08:00:06 +1100
User-Agent: KMail/1.9.5
Cc: michael chang <thenewme91@gmail.com>, ck mailing list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200702162110.03355.kernel@kolivas.org> <200702171417.28376.kernel@kolivas.org> <45D74D34.5020201@redhat.com>
In-Reply-To: <45D74D34.5020201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702180800.07393.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 05:45, Chuck Ebbert wrote:
> Con Kolivas wrote:
> > Maintainers are far too busy off testing code for
> > 16+ cpus, petabytes of disk storage and so on to try it for themselves. 
> > Plus they worry incessantly that my patches may harm those precious
> > machines' performance...
>
> But the one I like, mm-filesize_dependant_lru_cache_add.patch,
> has an on-off switch.
>
> In other words it adds an option to do things differently.
> How could that possibly affect any workload if that option
> isn't enabled?

Swap prefetch not only has an on-off switch, you can even build your kernel 
without it entirely so it costs even less than this patch... I'm not going to 
support the argument that it might be built into the kernel and enabled 
unknowingly and _then_ cause overhead.

Oh and this patch depends on some of the code from the swap prefetch patch 
too. I guess since they're so suspicious of swap prefetch the swap prefetch 
patch can be ripped apart for the portions of code required to make this 
patch work.

Do you still want this patch for mainline?... 

-- 
-ck
