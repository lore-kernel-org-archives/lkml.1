Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbXLIPJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbXLIPJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 10:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXLIPJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 10:09:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:21280 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXLIPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 10:09:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=D/VPtmVS4HS5c1IHh6ANyRUC87JgwOu8mxQvU2Sxd3XXfr8R4nfx4zxqz0bGUNE5KtyfZPZPA77PM1ycAmUXCPvAe825FTgWt97X6x1NOO9+XrSUYiO/Tw1bhbjOHlMLLd4x5g5Gvw2wN4E+JFzHtuAl77XAp/lHmWqyVRAchXs=
Message-ID: <475C0522.7080702@gmail.com>
Date: Mon, 10 Dec 2007 00:09:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <200712080340.49546.rjw@sisk.pl>	<20071208015227.3a1c7fae.akpm@linux-foundation.org>	<475B9270.6070902@gmail.com> <20071209134217.7ff02dd2@the-village.bc.nu>
In-Reply-To: <20071209134217.7ff02dd2@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
>> will break some other cases which were fixed by the change but those
>> won't be regressions at least and we can add transfer chunk size
>> update with other changes to 2.6.25.
> 
> Great, make everyone else wait another three months for a working CD
> drive. The one off regression appears far less harmful than a revert.

Newly broken ones will be regressions.  How many do we fix by the
change?  On SATA, setting the correct transfer chunk size doesn't seem
to fix many.

> Tejun - instead of backing out important updates for 2.6.24 we should
> just blacklist that specific drive for now and sort it nicely in 2.6.25,
> not revert stuff and break everyone elses ATAPI devices.

We'll need to blacklist setting transfer chunk size, eek, and let's
leave that as the last resort and hope that we find the solution soon.
Blacklist takes time to develop and temporary blacklist for just one
release doesn't sound like a good idea.

-- 
tejun
