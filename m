Return-Path: <linux-kernel-owner+w=401wt.eu-S1030479AbXCLQD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030479AbXCLQD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030481AbXCLQD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:03:26 -0400
Received: from rtr.ca ([64.26.128.89]:2534 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030479AbXCLQDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:03:24 -0400
Message-ID: <45F579CF.7040802@rtr.ca>
Date: Mon, 12 Mar 2007 12:03:27 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com>
In-Reply-To: <20070312152920.GA29597@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> ..
> And all of those fixes Oliver is referring to should be in anything
> older than 2.6.21-rc3-git6.

Did you mean, "anything *newer* than -git6" ??

This last crash was with -git4.  I'm building -git7 now.

>Does userspace have it open when you suspend/resume?

For the ooops I just posted, yes, I may have left Linux ckermit
running on the serial port before the suspend.

We shouldn't be oopsing regardless, but perhaps that could help
narrow things down a bit.

I'll also retest the simple plug-unplug-oops crash reported earlier,
once I have rc3-git7 up and running.

Cheers
