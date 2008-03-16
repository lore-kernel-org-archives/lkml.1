Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYCPOar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYCPOar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYCPOah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:30:37 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59640 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbYCPOah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:30:37 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <200803161529.48527.bzolnier@gmail.com> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101504.17219.bzolnier@gmail.com> <20080316140118.891732DC044@tippex.mynet.homeunix.org> <200803161529.48527.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Sun, 16 Mar 2008 15:29:47 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 16 Mar 2008 15:29:00 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080316142901.015342DC044@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1Jatrp-00075h-4Z.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Jatrp-00075h-4Z 5fc72bf455d36f8744fe4fdddf46756d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bzolnier@gmail.com said:
> This commit is also _after_ the previously "guilty" one (commit
> 852738f39258deafb3d89c187cb1a4050820d555)?

Yep.

> IIRC we've agreed that bisection between 2.6.24 and commit 8527* was needed?

I did that first, and it pointed to  8527* as the bad one. During this bisect 
I took care to always start from a 2.6.24 .config, and do a make oldconfig from 
that. A clean series of good emerged.. Unfortunately I don't have the configs 
from the previous runs saved.

Given this, I concluded that the configs had to play a role in making a 
version go bad, so I decided to do another one between  8527* and 2.6.25-rc1
always based on the  8527* config (which _worked_ when tested with the 2.6.24 
config dragged forward. So the upped end of the first bisect was badly chosen)

The attahed was the result of that latter run...

> Thanks, 



