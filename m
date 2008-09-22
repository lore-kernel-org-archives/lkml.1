Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYIVVWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYIVVWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYIVVWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:22:48 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:36393 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYIVVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:22:48 -0400
Message-ID: <48D80C9C.2070108@nortel.com>
Date: Mon, 22 Sep 2008 15:22:36 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
References: <20080919.234824.223177211.davem@davemloft.net>
In-Reply-To: <20080919.234824.223177211.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2008 21:22:38.0047 (UTC) FILETIME=[56808EF0:01C91CF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Jens Axboe has written some hacks for the block layer that allow
> queueing softirq work to remote cpus.  In the context of the block
> layer he used this facility to trigger the softirq block I/O
> completion on the same cpu where the I/O was submitted.

<snip>

> I intend to use this
> for receive side flow seperation on non-multiqueue network cards.

I'm not sure this belongs in this particular thread but I was
interested in how you're planning on doing this?  Is there going to be a
way for userspace to specify which traffic flows they'd like to direct
to particular cpus, or will the kernel try to figure it out on the fly?

We have application guys that would like very much to be able to nail 
specific apps to specific cores and have the kernel send all their 
packets to those cores for processing.

Chris
