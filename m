Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXD1UAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXD1UAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXD1UAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:00:41 -0400
Received: from www.osadl.org ([213.239.205.134]:42978 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570AbXD1UAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:00:04 -0400
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Bill Davidsen <davidsen@tmr.com>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
In-Reply-To: <4633A6D7.3030806@tmr.com>
References: <20070427224957.GA17967@kroah.com>  <4633A6D7.3030806@tmr.com>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 22:02:05 +0200
Message-Id: <1177790525.7646.275.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 15:56 -0400, Bill Davidsen wrote:
> Greg KH wrote:
> > Here are the updated UIO (Userspace I/O driver framework) patches for
> > 2.6.21.
> > 
> > They have been revamped from the last time you have seen them, and they
> > include a real driver, the Hilscher CIF DeviceNet and Profibus card
> > controller, which is being used in production systems with this driver
> > framework right now.  The kernel driver they replaced was a total mess,
> > with over 60+ ioctls to try to control the different aspects of the
> > device.  See the last patch in this series for more details on this
> > driver.
> > 
> I have a political question, if I have a user space driver, is my kernel 
> tainted or not? Does this open another multi-month flame war around GPL, 
> BSD, NDA, source available but not GPL, and all the other things we 
> talked to death about inserting non-GPL modules?

The kernel driver has to be GPL, the user space part can be as any user
space code closed source. Of course we recommend to make it open as
those user space drivers which we did so far are all licensed under
LPGL.

There is nothing to flame, the user space boundary is entirely clear.

	tglx


