Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXCVPej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXCVPej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933258AbXCVPej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:34:39 -0400
Received: from www.osadl.org ([213.239.205.134]:54636 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933245AbXCVPei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:34:38 -0400
Subject: Re: sysfs ugly timer interface (was Re: [BUG] 2.6.21-rc1,2,3
	regressions on my system that I found so far)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>, Maxim <maximlevitsky@gmail.com>,
       Andrew Morton <akpm@osdl.org>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070322152842.GA6054@kroah.com>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <200703161919.44458.lenb@kernel.org>
	 <200703180100.01889.maximlevitsky@gmail.com> <20070320115403.GA3983@ucw.cz>
	 <20070322152842.GA6054@kroah.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 16:41:53 +0100
Message-Id: <1174578114.10840.194.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 08:28 -0700, Greg KH wrote:
> On Tue, Mar 20, 2007 at 11:54:03AM +0000, Pavel Machek wrote:
> > Hi!
> > 
> > > root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered
> > > lapic                F:0007 M:3(periodic) C: 1
> > > hpet                 F:0003 M:1(shutdown) C: 0
> > > lapic                F:0007 M:3(periodic) C: 0
> > > root@MAIN:/home/maxim#   
> > 
> > Now... this file needs to die, before 2.6.21 is released. It tries to
> > bring /proc-like parsing nightmare to sysfs. Kill it before it becomes
> > part of stable ABI!
> 
> Eeek!
> 
> I agree, that needs to be fixed now.
> 
> Remember, 1 value per file in sysfs!  Shall I just submit a patch
> ripping it out for now?

I fix it.

	tglx


