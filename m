Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYKTAlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYKTAlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYKTAlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:41:37 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60278 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbYKTAlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:41:37 -0500
Message-ID: <4924B23C.6050300@euromail.se>
Date: Thu, 20 Nov 2008 01:41:32 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Complete support for the new unibody macbooks
References: <49109C91.6090207@euromail.se> <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz> <4919C979.3000501@euromail.se> <alpine.LNX.1.10.0811112347260.24889@jikos.suse.cz> <20081119113753.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0811191803320.19853@jikos.suse.cz> <49249431.9040104@euromail.se> <alpine.LNX.1.10.0811192339560.19853@jikos.suse.cz> <49249CCB.7060807@euromail.se> <alpine.LNX.1.10.0811200056240.19853@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811200056240.19853@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1L2xby-0002XL-4d.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1L2xby-0002XL-4d fb7fa9b4d72a11d524234b4be3e78902
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 20 Nov 2008, Henrik Rydberg wrote:
> 
>>> Therefore my memory must have been wrong -- I thought that you told me 
>>> when I was merging f89bd95c5c that the devices are not standard HID 
>>> devices at all, and therefore they can be safely ignored by the driver 
>>> right away, as they can't be driven by HID driver anyway.
>> These usb devices provide several different functions through the same
>> interface. By default, it looks like a regular mouse interface, which
>> HID will claim. This is why we need the quirks.
> 
> That I fully understand. But I though that the device is so much HID 
> standard non-compliant, that even basic functionality is not possible with 
> the generic HID driver, and therefore blacklisting it immediately can't do 
> any harm. That's what I understood previously. But if this is wrong, and 
> the HID code can get at least basic functionality from the device, I will 
> revert the blacklist addition.

Basic functionality is possible with the generic HID driver.

Thanks,
Henrik

