Return-Path: <linux-kernel-owner+w=401wt.eu-S1031225AbXD1Tzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031225AbXD1Tzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031248AbXD1Tzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:55:38 -0400
Received: from mail.tmr.com ([64.65.253.246]:49358 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031225AbXD1TzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:55:03 -0400
Message-ID: <4633A6D7.3030806@tmr.com>
Date: Sat, 28 Apr 2007 15:56:07 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
References: <20070427224957.GA17967@kroah.com>
In-Reply-To: <20070427224957.GA17967@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Here are the updated UIO (Userspace I/O driver framework) patches for
> 2.6.21.
> 
> They have been revamped from the last time you have seen them, and they
> include a real driver, the Hilscher CIF DeviceNet and Profibus card
> controller, which is being used in production systems with this driver
> framework right now.  The kernel driver they replaced was a total mess,
> with over 60+ ioctls to try to control the different aspects of the
> device.  See the last patch in this series for more details on this
> driver.
> 
I have a political question, if I have a user space driver, is my kernel 
tainted or not? Does this open another multi-month flame war around GPL, 
BSD, NDA, source available but not GPL, and all the other things we 
talked to death about inserting non-GPL modules?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
