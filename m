Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbXCEVrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbXCEVrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933651AbXCEVrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:47:41 -0500
Received: from twin.jikos.cz ([213.151.79.26]:40572 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933647AbXCEVrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:47:40 -0500
Date: Mon, 5 Mar 2007 22:47:10 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Li Yu <raise.sail@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
Subject: Re: [DOC] The documentation for HID Simple Driver Interface 0.5.0
In-Reply-To: <1173127471.6638.96.camel@aeonflux.holtmann.net>
Message-ID: <Pine.LNX.4.64.0703052244490.10909@twin.jikos.cz>
References: <200703051532096508636@gmail.com> <1173127471.6638.96.camel@aeonflux.holtmann.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Marcel Holtmann wrote:

> actually, I don't think we need a simple driver interface. We need a HID 
> driver interface in general. For example that you can register a driver 
> for one or multiple report ID and then it handles input and output for 
> these report IDs. This also means that the current keyboard and mouse 
> input devices will become a HID driver.

Hi Marcel,

sorry, this is not clear to me - what keyboard and mouse devices are you 
talking here precisely? As not all keyboard and mouse devices are HID, 
this is probably not what you've meant ... ? Thanks.

> In addition to the kernel HID driver we might also when have a new 
> hidraw (or modified hiddev) interface that allows to handle specific 
> report ID from a userspace application. Especially when it comes to LED 
> displays or UPS systems.

I have already written some code of hidraw interface, but it's not yet 
finished due to too many other pending things.

Thanks,

-- 
Jiri Kosina
