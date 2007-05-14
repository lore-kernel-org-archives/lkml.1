Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbXENX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbXENX2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXENX2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:28:11 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:49477 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXENX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:28:10 -0400
Message-ID: <4648F04B.9050204@gentoo.org>
Date: Mon, 14 May 2007 19:27:07 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kevin Lloyd <klloyd@sierrawireless.com>
CC: gregkh@suse.de, mdharm-usb@one-eyed-alien.net,
       linux-usb-users@lists.sourceforge.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-storage: Add support for unusual device by Sierra
 Wireless
References: <4648D851.2030500@sierrawireless.com> <4648E9CB.2000509@gentoo.org> <3415E2A2AB26944B9159CDB22001004D01773F61@nestea.sierrawireless.local>
In-Reply-To: <3415E2A2AB26944B9159CDB22001004D01773F61@nestea.sierrawireless.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Lloyd wrote:
> Not a bad idea. When using the US_FL_IGNORE_DEVICE flag, that causes the
> usb-storage driver to no load the device and allow another driver
> properly load it? The reason I ask is because I previously had a
> separate driver for the device, however there were priority issues
> regarding which loaded first usb-storage or the separate driver.

Yes, that's what it's designed for. If usb-storage does come first, the 
US_FL_IGNORE_DEVICE flag causes it to return -ENODEV from probe, which 
causes the driver core to look for other candidate drivers to claim the 
device.

Daniel
