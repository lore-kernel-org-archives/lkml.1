Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0CISAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:00:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50539 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab0CISA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:00:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B968CA2.4040000@s5r6.in-berlin.de>
Date: Tue, 09 Mar 2010 19:00:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] ar9170: fix for driver-core ABI change
References: <20100309104221.aedc5e7e.sfr@canb.auug.org.au> <20100309125245.c25e5ca4.sfr@canb.auug.org.au>
In-Reply-To: <20100309125245.c25e5ca4.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Greg tells me that the semaphore to mutex change didn't go into Linus'
> tree.  However, this patch can still be applied as the device_lock/unlock
> primitives did go in.  I guess that the include of mutex.h is not needed.

An #include <linux/device.h> seems to be in order though.  It is pulled
in via linux/usb.h and this is surely not bound to change anytime soon,
but still.
-- 
Stefan Richter
-=====-==-=- --== -=--=
http://arcgraph.de/sr/
