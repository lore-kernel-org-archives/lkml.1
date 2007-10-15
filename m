Return-Path: <linux-kernel-owner+w=401wt.eu-S933597AbXJOSWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbXJOSWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbXJOSWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:22:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56982 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760886AbXJOSWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:22:07 -0400
Message-ID: <4713AFC3.8000403@pobox.com>
Date: Mon, 15 Oct 2007 14:21:55 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen-netfront: use net_device's stats structure
References: <470C2737.60403@goop.org>
In-Reply-To: <470C2737.60403@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> struct net_device has its own stats structure, so use that instead.
> Also, we can use the default get_stats function.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/net/xen-netfront.c |   25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)

ACK patches 1-3, but they still do not apply.

Since net-2.6.24 has gone upstream, you may send diffs against 
torvalds/linux-2.6.git if you like -- there are no outstanding 
dependencies at this time.


