Return-Path: <linux-kernel-owner+w=401wt.eu-S965044AbXCSAZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbXCSAZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 20:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965034AbXCSAZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 20:25:41 -0400
Received: from zoot.lnxi.com ([63.145.151.20]:44862 "EHLO zoot.lnxi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964974AbXCSAZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 20:25:39 -0400
X-Greylist: delayed 7267 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Mar 2007 20:25:39 EDT
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318202559.GD11078@mellanox.co.il>
From: ebiederman@lnxi.com (Eric W. Biederman)
Date: Sun, 18 Mar 2007 16:24:23 -0600
In-Reply-To: <20070318202559.GD11078@mellanox.co.il> (Michael S. Tsirkin's
 message of "Sun, 18 Mar 2007 22:25:59 +0200")
Message-ID: <m3tzwi8a20.fsf@maxwell.lnxi.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@dev.mellanox.co.il> writes:

>> > Why is neighbour->dev changed here?
>> 
>> It holds reference to device and prevents its destruction.
>> If dst is held somewhere, we cannot destroy the device and deadlock
>> while unregister.
>
> BTW, can this ever happen for the loopback device itself?
> Is it ever unregistered?

Well I don't think the loopback device is currently but as soon
as we get network namespace support we will have multiple loopback
devices and they will get unregistered when we remove the network
namespace.

Eric
