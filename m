Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYIXRW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYIXRW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYIXRWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:22:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:60319 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYIXRWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:22:20 -0400
Message-ID: <48DA774A.9010206@mvista.com>
Date: Wed, 24 Sep 2008 10:22:18 -0700
From: Drew Moseley <dmoseley@mvista.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Create PNP device attributes via dev_attrs field of struct
 device
References: <48D95EA2.9040804@mvista.com> <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>
In-Reply-To: <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> 
> Any reason not to assign it statically to pnp_bus_type at in
> drivers/pnp/driver.c?
> 
> Thanks,
> Kay

Not really but since everything in the dev_attrs array is statically
defined in interface.c it was simpler to implement it this way.  To
assign it in driver.c, the array can be made non-static and an extern
added in driver.c, or the array definition can be moved to driver.c and
all the set and show functions be made non-static.  Is there a preference?

Thanks,
Drew
