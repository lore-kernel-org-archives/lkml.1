Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYF1OjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYF1OjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYF1OjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:39:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50732 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYF1OjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:39:12 -0400
Message-ID: <48664B4A.9090308@nokia.com>
Date: Sat, 28 Jun 2008 17:31:38 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
CC: ext Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
References: <Pine.LNX.4.44L0.0806261018340.2811-100000@iolanthe.rowland.org> <48641325.2020903@nokia.com> <200806270907.37245.david-b@pacbell.net>
In-Reply-To: <200806270907.37245.david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 14:32:23.0117 (UTC) FILETIME=[C755CFD0:01C8D92B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

ext David Brownell wrote:
> 
> If 442258e2ff69276ff767f3703b30ce6a31fdd181 isn't in the
> kernel with those bugs, try applying it... else, I suggest

That commit is about 4 months later than the commit I tracked down with 
git bisect. I'm currently testing with 2.6.26-rc8, so that commit is in.

> you try putting something like your
> 
> 	if (!raw_irqs_disabled()) {
> 		printk(KERN_CRIT "interrupts enabled!\n");
> 		dump_stack();
>         }
> 
> logic at the beginning and end of usb_hcd_giveback_urb ... and
> maybe have it dump the address of the completion handler, when
> you can finger such a handler as re-enabling IRQs.

See my reply to Alan's mail...

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
