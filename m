Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXCLQWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXCLQWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030587AbXCLQWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:22:13 -0400
Received: from rtr.ca ([64.26.128.89]:1655 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030586AbXCLQWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:22:11 -0400
Message-ID: <45F57E32.6020505@rtr.ca>
Date: Mon, 12 Mar 2007 12:22:10 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com> <45F579CF.7040802@rtr.ca> <20070312161016.GA463@kroah.com>
In-Reply-To: <20070312161016.GA463@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>
> thanks, but again, which usb-serial device do you have running here?

That's in the oops log:  pl2303 for the ckermit test.

For the other oops (plug/wait/unplug a multi-func hub), one of the hubs
also has a pl2303, the other has an mct_u232.

Cheers

-ml
