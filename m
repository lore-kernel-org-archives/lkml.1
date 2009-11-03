Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZKCNIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZKCNIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZKCNIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:08:50 -0500
Received: from mail.ebim.net ([212.108.130.11]:2261 "EHLO ebim.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752713AbZKCNIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:08:49 -0500
Subject: Re: Faulty MTRR setups in Toshiba laptops crash video drivers
From: Mehmet Giritli <mehmet@giritli.eu>
Reply-To: mehmet@giritli.eu
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4AEF7402.1010901@gmail.com>
References: <1257179328.13327.34.camel@frodo.giritli.eu>
	 <4AEF7402.1010901@gmail.com>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 15:08:33 +0200
Message-Id: <1257253713.6277.7.camel@frodo.giritli.eu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 18:06 -0600, Robert Hancock wrote:
> On 11/02/2009 10:28 AM, Mehmet Giritli wrote:
> > Hello all,
> >
> > On some laptops using ATI 3650HD radeon chipsets and 4GB ram (and may be
> > others as well), it is impossible to start any xserver due to (faulty?)
> > mtrr setups on the machine. The computer locks up or just gives an
> > unresponsive black screen. There are various drivers for radeon cards
> > and the crash occurs in all of these drivers in the very same way!
> >
> > This bug seems to occur mostly on Toshiba laptops with ATI graphic
> > cards. For some people, CONFIG_MTRR_SANITIZER seemed to cure the issue
> > but made no difference for many others like me.
> >
> > RadeonHD people seem to have problems in understanding the nature of
> > this bug. Please have a look at the threads:
> >
> > http://lists.opensuse.org/radeonhd/2009-05/msg00040.html
> >
> > and,
> >
> > http://bugs.freedesktop.org/show_bug.cgi?id=20645
> >
> > for problem reports and dev responses. RadeonHD devs suggest that some
> > laptops have weird mtrr setups and this must be fixed in the kernel code
> > and not the driver code.
> 
> Unfortunately I don't see enough details to be able to tell what lead 
> them to this conclusion. Can you post the output of:
> 
> lspci -vv
> cat /proc/mtrr

lspci -vv
http://bugzilla.kernel.org/attachment.cgi?id=23634

/proc/mtrr when 4GB installed
http://bugzilla.kernel.org/attachment.cgi?id=23632

/proc/mtrr when 2GB installed
http://bugzilla.kernel.org/attachment.cgi?id=23633

There is also a bug report that I opened a while back here:
http://bugzilla.kernel.org/show_bug.cgi?id=14054



> 
> >
> > Currently, the only way that could make the driver work is to reduce the
> > 4GB ram to 2GB.
> >
> > dmesg from my affected machine when it has 4GB ram installed can be
> > found here:
> >
> > http://bugzilla.kernel.org/attachment.cgi?id=22856
> >
> > Also, look at the report here:
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/341681
> >
> > in order to see how many people are being affected by this bug!
> >
> > Kind Regards,
> > M. Giritli
> >
> >
> 


