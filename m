Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYCPTlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYCPTlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYCPTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:40:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbYCPTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:40:53 -0400
Date: Sun, 16 Mar 2008 12:39:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <20080316185602.79064f7c@core>
Message-ID: <alpine.LFD.1.00.0803161238190.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080316140118.891732DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com>
 <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org> <20080316185602.79064f7c@core>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Mar 2008, Alan Cox wrote:
> 
> No it doesn't. DRQ simply means "drive has more data for the controller
> if you want it". Interrupts are controlled via IEN and the interrupt line.

A _lot_ of chips require you to clear the DRQ by taking the data they 
have.

> If the drive wants to give us data and we end the transaction that is
> fine. In practice a tiny few devices crap themselves if we don't.

More than a few tiny devices from what I remember. It tends to be the 
other way around - most devices do *not* want to get new commands until 
you've finished the previous one by draining the queues.

		Linus
