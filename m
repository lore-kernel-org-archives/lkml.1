Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXGIR4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXGIR4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXGIR4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:56:25 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:55905 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbXGIR4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:56:24 -0400
Date: Mon, 9 Jul 2007 12:56:01 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       David Greaves <david@dgreaves.com>
cc: Mark Lord <liml@rtr.ca>, Douglas Gilbert <dougg@torque.net>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: SMART problems in 2.6.22
In-Reply-To: <4692221B.7050608@dgreaves.com>
Message-ID: <Pine.LNX.4.63.0707091236530.7386@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
 <4692221B.7050608@dgreaves.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg164863.html

> This is mine and although it's a 'real' problem, it is something that's easy 
> to hack around by having the suspend script turn on smart after it is 
> resumed. (Of course I can't use resume until a skge wol bug is fixed so I 
> won't see/test this unless asked too.)
>
> The smart init scripts run '-s on' when the system boots anyway for my system 
> - this problem only occurs for me during suspend/resume. Maybe smartd should 
> detect that as Alan says.

OK, that should be easy to do.  So let's forget about the 'SMART disabled' 
issue.  This is easy to fix in multiple ways and is not a LKML issue.

David: can you reproduce the more serious problem 
http://article.gmane.org/gmane.linux.utilities.smartmontools/4712 reported 
by Jan Dvorak?

Jeff: this is the problem that really has me concerned.

Jan: what happens if you replace '-d ata' with '-d sat'?  This option 
should be available in the 5.37 release of smartmontools that you are 
using unless the Suse package maintainer is playing games with the version 
numbers.

Unfortunately I don't think this will fix the problem, as the bug report 
by Klaus Fuerstberger 
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=428975 is using '-d sat'.

Jeff: the fact that both links given above are reporting the same bug in 
two different settings, and the fact that the bug goes away when reverting 
2.6.22 to 2.6.21 still has me concerned.

Cheers,
 	Bruce
