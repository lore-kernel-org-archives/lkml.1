Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYBVWAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYBVWAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760201AbYBVWAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:00:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52602 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYBVWAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:00:08 -0500
Message-ID: <47BF45E4.4020006@garzik.org>
Date: Fri, 22 Feb 2008 17:00:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
CC: Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <47BF0DCD.4060400@garzik.org> <20080222185645.9DD9C93C12F@tippex.mynet.homeunix.org> <47BF3DE3.4000100@rtr.ca> <20080222213932.3403F93C12F@tippex.mynet.homeunix.org>
In-Reply-To: <20080222213932.3403F93C12F@tippex.mynet.homeunix.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Eriksson wrote:
> Is smartd prepared to handle /dev/sdX style devices?

Yes.  You need to pass "-d ata" to smartd and smartctl, if your scripts 
are not already doing so.


> If this is the prefered driver these days, maybe it shouldn't be marked 
> experimental in the menu anymore?

It's not marked experimental.

	Jeff


