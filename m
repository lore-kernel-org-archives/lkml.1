Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXCMNjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXCMNjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965719AbXCMNjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:39:41 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:4955 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965715AbXCMNjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:39:40 -0400
Message-ID: <45F6A99A.8060008@rtr.ca>
Date: Tue, 13 Mar 2007 09:39:38 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
Cc: Jim Radford <radford@blackbean.org>, Greg KH <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression fix
References: <45F57F63.7010308@rtr.ca> <45F60482.6010501@rtr.ca> <20070313091408.GA7205@blackbean.org> <200703131114.48068.oneukum@suse.de>
In-Reply-To: <200703131114.48068.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
>
> If we get to destroy_serial(), how can ports still be open?

(1) open up a ckermit session on /dev/usb_serial_port_0.
(2) suspend the machine (to RAM).
(3) the suspend logic "removes" all USB devices.

Cheers
