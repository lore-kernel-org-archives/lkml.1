Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbXHUNFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbXHUNFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 09:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXHUNFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 09:05:38 -0400
Received: from twin.jikos.cz ([213.151.79.26]:44471 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbXHUNFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 09:05:38 -0400
Date: Tue, 21 Aug 2007 15:05:25 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Florin Iucha <florin@iucha.net>
cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <20070821125718.GH10422@iucha.net>
Message-ID: <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz>
 <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
 <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Florin Iucha wrote:

> I have rebuilt 2.6.23-rc3 with 'CONFIG_USB_EHCI_HCD=m' and 
> 'CONFIG_USB_SUSPEND is not set' and will use it for a while, to see if 
> the keyboard/usb behaves or not.

Thanks. If this doesn't give us any hint, it would be useful if you could 
do git-bisect between rc2 and rc3, I really can't immediately see anything 
in the list of commits that might directly cause the behavior you are 
seeing (most importantly because there were no USB and no HID updates in 
this window).

There are approximately 290 commits, so it shouldn't require more than 9 
reboots plus the time needed to check whether the bug triggers or not.

Thanks,

-- 
Jiri Kosina
