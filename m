Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYBVSBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYBVSBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760544AbYBVSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:00:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40928 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223AbYBVSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:00:49 -0500
Message-ID: <47BF0DCD.4060400@garzik.org>
Date: Fri, 22 Feb 2008 13:00:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org>
In-Reply-To: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Eriksson wrote:
> Hi,
> 
> Trying out 2.6.25-rc2 smartd always causes my box to hang. I can switch 
> vt:s and the keyboard seems to work.
> 
> Using sysrq-e I noticed a callpath open -> ext3 -> journals -> sync_buffer -> 
> io_scheduel -> generic_unplig_device.
> 
> I'd guess the open stems from smartd. Removing smartd from the startup, I'm 
> now using rc2 fine...
> 
> I got a nice jpg showing it as well.

The sysrq-e output is probably just standard ext3 journalling unrelated 
to the problem...  what does dmesg say?  lspci?  What's your hardware setup?

	Jeff



