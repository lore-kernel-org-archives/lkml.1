Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYCPSOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYCPSOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCPSOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:14:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbYCPSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:14:32 -0400
Date: Sun, 16 Mar 2008 11:13:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <200803161907.04581.bzolnier@gmail.com>
Message-ID: <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080316140118.891732DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> We don't do error handling for special commands (REQ_TYPE_ATA_*) at all,
> ide_error() just dumps device's status/error register(s) and finishes early:

Well that sounds bogus too, for all the same reasons already outlined. The 
DRQ flag needs to be cleared up on error!

> Moreover the problem was initially narrowed down to commit
> 852738f39258deafb3d89c187cb1a4050820d555 which is two commits _before_
> the one that we are currently discussing.

.. and that initial narrowing down is now in doubt, with the new one 
pointing to that DRQ-logic-changing commit!

IOW, Anders re-did things more carefully, and came to a new result. Why 
are you apparenrly ignoring that fact?

			Linus
