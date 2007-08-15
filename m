Return-Path: <linux-kernel-owner+w=401wt.eu-S933269AbXHOO7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbXHOO7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764687AbXHOO6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:58:48 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36850 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764473AbXHOO6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:58:47 -0400
Date: Wed, 15 Aug 2007 16:58:33 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Florin Iucha <florin@iucha.net>
cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <20070815145313.GC7124@iucha.net>
Message-ID: <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz>
 <20070815145313.GC7124@iucha.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Florin Iucha wrote:

> [See my message to Alan]: It happened twice, within 15 minutes of 
> boot+login, with 2.6.23-rc3-$whatever .  I does not happen with 
> 2.6.2[123](-rc*)?  After the two incidents, I rebooted in 2.6.23-rc2 and 
> it is working for an hour now.

It is not immediately clear what might be causing this, 2.6.23-rc3 didn't 
get any USB nor HID updates at all compared to 2.6.23-rc2.

Could you please enable USB and HID debugging to see whether we can see 
anything spurious in the logs at the time the keyboard gets stuck?

Bisecting this might be a bit painful if it is not reproducible in 
predictable timeframes :(

-- 
Jiri Kosina
