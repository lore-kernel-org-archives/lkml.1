Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbXEGDeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbXEGDeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 23:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXEGDeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 23:34:23 -0400
Received: from smtpout.mac.com ([17.250.248.186]:52242 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXEGDeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 23:34:22 -0400
In-Reply-To: <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280041.17617.rjw@sisk.pl> <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org> <200704280145.26253.rjw@sisk.pl> <1177718250.4737.222.camel@nigel.suspend2.net> <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz> <20070503171843.GA4355@ucw.cz> <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CF6D1CC2-4B42-4FF9-821F-C54C4553D710@mac.com>
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Back to the future.
Date: Sun, 6 May 2007 23:33:11 -0400
To: David Lang <david.lang@digitalinsight.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 06, 2007, at 22:13:51, David Lang wrote:
> anyone who is doing a hibernate or suspend who expect all the  
> network connections to be working afterwords is dreaming or  
> smokeing something.
>
> this is just another way that the failure can show up.
>
> in fact, I would say that it would probalby be a nice thing to do  
> for intervening firewalls and external servers if a suspend closed  
> all external TCP connections rather then leaving them dangling  
> (eating up resources until they time out)
>
> if you software can't tolorate the network connection going away on  
> you it will have problems in normal operation anyway, let alone  
> when you suspend/hibernate your machine.

Yeah, for suspend-to-ram+resume and for snapshot+restore you probably  
want userspace to support some kind of initscript-like mechanism  
which is triggered by the lid-switch or something before calling into  
the kernel.  That way it can close network connections mostly-nicely  
and down network interfaces before suspending, then re-run DHCP/ 
802.11/whatever configuration after resume/restore.  That might not  
be a bad place to handle NFS mounts and such too.

Cheers,
Kyle Moffett

