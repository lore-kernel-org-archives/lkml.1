Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZGUTUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZGUTUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZGUTUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:20:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56059
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbZGUTUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:20:52 -0400
Date: Tue, 21 Jul 2009 12:20:58 -0700 (PDT)
Message-Id: <20090721.122058.23378599.davem@davemloft.net>
To: fthain@telegraphics.com.au
Cc: u.kleine-koenig@pengutronix.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com, geert@linux-m68k.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] move macsonic's probe function to .devinit.text
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.OSX.2.00.0907220032230.796@silk.local>
References: <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.OSX.2.00.0907220032230.796@silk.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Wed, 22 Jul 2009 01:14:36 +1000 (EST)

> 
> 
> On Sat, 11 Jul 2009, Uwe Kleine-K?nig wrote:
> 
>> A pointer to mac_sonic_probe is passed to the core via
>> platform_driver_register and so the function must not disappear when
>> the .init sections are discarded.  Otherwise (if also having
>> HOTPLUG=y) unbinding and binding a device to the driver via sysfs will
>> result in an oops as does a device being registered late.
> 
> This patch works for me (tested on a Quadra 630). I still get an oops
> on rmmod, but that's a separate issue. I'll send a patch for that.

Applied, but Uwe _please_ post networking patches to
netdev@vger.kernel.org so that they get properly logged
and tracked at:

http://patchwork.ozlabs.org/project/netdev/list/

Thank you.
