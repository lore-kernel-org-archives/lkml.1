Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbYC1CPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbYC1CPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYC1COy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:14:54 -0400
Received: from rtr.ca ([76.10.145.34]:2779 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbYC1COx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:14:53 -0400
Message-ID: <47EC549D.6090705@rtr.ca>
Date: Thu, 27 Mar 2008 22:14:53 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca>
In-Reply-To: <47EBBD57.30902@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> It is with great reluctance when I attempt moving my main "desktop"
> over to a new kernel version -- because the USB subsystem seems to
> break every single time.
> 
> So today I tried 2.6.25-rc7 on it for the first time.
> Not good.
> 
> It boots, but just a simple suspend/resume (RAM) was enough to kill it.
> It comes back on resume, with an X desktop again,
> but with no USB functionality -- no mouse.
> 
> The keyboard still works, so I dropped to a console and tried:
> 
>   rmmod usbhid
>   insmod usbhid
> 
> And the console hung at 100% CPU on the insmod.
> Back to 2.6.24.3 again, for now -- I've got work to do.
> 
> The specs of this machine have been posted with great regularity
> in the past, every new kernel revision it seems.   So here we go again:
> 
> Dell Inspiron 9400 notebook, Intel Core2Duo T7400, 2GB SDRAM.
..

Correction there:  3GB of RAM, not 2.

