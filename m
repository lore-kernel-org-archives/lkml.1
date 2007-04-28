Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXD1UD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXD1UD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbXD1UD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:03:58 -0400
Received: from www.osadl.org ([213.239.205.134]:46435 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754132AbXD1UD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:03:57 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Date: Sat, 28 Apr 2007 22:03:30 +0200
User-Agent: KMail/1.9.5
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <4633A6D7.3030806@tmr.com>
In-Reply-To: <4633A6D7.3030806@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282203.31141.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 21:56 schrieb Bill Davidsen:
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
> tainted or not? 

Surely not. By using the kernel's userspace interface, you create no
"derived work" of the kernel. See COPYING in the root directory of the 
kernel sources for details.

> Does this open another multi-month flame war around GPL,  
> BSD, NDA, source available but not GPL, and all the other things we 
> talked to death about inserting non-GPL modules?

Hopefully not. BTW, all existing UIO userspace drivers I know about 
are GPL or LGPL.

Hans

