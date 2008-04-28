Return-Path: <linux-kernel-owner+w=401wt.eu-S934693AbYD1SAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbYD1SAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934454AbYD1R7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:59:41 -0400
Received: from minx.mdc-dayton.com ([70.62.41.4]:48321 "EHLO daetwyler-rd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934384AbYD1R7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:59:40 -0400
From: "Kathy Frazier" <kfrazier@daetwyler-rd.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Kathy Frazier'" <kfrazier@daetwyler-rd.com>
Cc: "'Kathy Frazier'" <kfrazier@daetwyler-rd.com>,
       <linux-kernel@vger.kernel.org>
References: <009501c89e28$3d7530f0$b85f92d0$@com>	<20080414133937.7080d30d@core>	<006f01c8a4a7$82e37ea0$88aa7be0$@com> <20080425181219.61e29b1f@core>
In-Reply-To: <20080425181219.61e29b1f@core>
Subject: RE: Talking to parallel port in 2.6 kernel without using parport
Date: Mon, 28 Apr 2008 13:59:26 -0400
Message-ID: <003f01c8a959$9a915b60$cfb41220$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acim+HetRg3vdLwRTgm/5GyNr8MJ5QCYIevg
Content-Language: en-us
X-MyHeader: SpamAssassin Check skipped due to Authenication or Internal MDC-Dayton Address
X-MyHeader: Clam AV Check skipped due to Authenication or Internal MDC-Dayton Address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

That was a problem!  The lp driver was already loaded.  If I remove it and
then load my driver, it returns with success from parport_register_device.
Thanks for your help!

Regards,
Kathy

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Friday, April 25, 2008 1:12 PM
To: Kathy Frazier
Cc: 'Kathy Frazier'; linux-kernel@vger.kernel.org
Subject: Re: Talking to parallel port in 2.6 kernel without using parport

> One of our engineers downloaded source code a while back from 
> linux-2.6.18-rc7, but I am not sure how close that is to what is 
> installed on my system (uname -r returns 2.6.18-1.2798.fc6.  When I 
> set my printk to 8 (echo 8 > /proc/sys/kernel/printk), there are no 
> messages shown on the failure.  According to the source code I have, 
> the only silent failure in parport_register_device is:

Nothing immediately strikes me.

> When I change the flags from PARPORT_FLAG_EXCL to 0 in the call to 
> parport_register_device, the call returns a non-zero to indicate success.

Do you have the printer driver loaded already ? (and does it behave if you
do rmmod lp first)

> Can you tell me what I am missing?  Where can I get the actual source 
> code that goes with this version to further unravel this?

>From the .fc6 it would be an old Fedora kernel so very close to standard
2.6.18 from kernel.org, but the Fedora Core kernels are available from the
Fedora download pages - the .srpm package for each kernel is the one
matching the same binary - so google for "2.6.18-1.2798.fc6.src.rpm"

http://www.mjmwired.net/resources/mjm-fedora-fc6.html has a few notes on it.


To be honest this area of the kernel hasn't changed much over recent times.
Let me know if you can't figure out what is going on.

