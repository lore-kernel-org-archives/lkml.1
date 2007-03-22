Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbXCVHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbXCVHj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbXCVHj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:39:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbXCVHjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:39:25 -0400
Date: Wed, 21 Mar 2007 23:39:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070321233917.0393dfd1.akpm@linux-foundation.org>
In-Reply-To: <20070321202225.GN10459@waste.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	<4601761F.4000302@lwfinger.net>
	<20070321185900.GC3801@tuxdriver.com>
	<20070321202225.GN10459@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 15:22:25 -0500 Matt Mackall <mpm@selenic.com> wrote:

> With the latest -mm, I'm now getting this:
> 
> Mar 21 15:06:52 cinder kernel: ipw2200: Detected Intel PRO/Wireless
> 2200BG Network Connection
> Mar 21 15:06:52 cinder kernel: firmware_loading_store: unexpected
> value (0)
> Mar 21 15:06:52 cinder kernel: ipw2200: ipw2200-bss.fw
> request_firmware failed:
> Reason -2
> Mar 21 15:06:52 cinder kernel: ipw2200: Unable to load firmware: -2
> Mar 21 15:06:52 cinder kernel: ipw2200: failed to register network
> device

The firmware loading bug is caused by
driver-core-handles-kobject_uevent-failure-while-device_add.patch

I've uploaded a revert patch to
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/hot-fixes/

