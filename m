Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXGIAoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXGIAoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 20:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXGIAnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 20:43:51 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:39037 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXGIAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 20:43:51 -0400
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2007 20:43:50 EDT
Date: Sun, 8 Jul 2007 19:32:49 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Jan Dvorak <fermentol@gmail.com>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: SMART problems in 2.6.22
Message-ID: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, David, Doug, Tejin, Alan, Jeff, LKML,

I'm afraid that there may be some problem with SMART + libata in the 
2.6.22 kernel.  An hour ago I discovered that I missed a month of 
correspondence (some LKML, some private) about this problem which Alan, 
Tejun, Jeff, Mark and others copied to me -- it was automatically shoved 
into one of my mailboxes by my mail client.  Sorry about that.  So I am 
trying to catch up to see if there is some real problem or not.

Here is a typical bug report that worries me:
http://article.gmane.org/gmane.linux.utilities.smartmontools/4712

Here is another similar report:
http://thread.gmane.org/gmane.linux.utilities.smartmontools/4713

And another report:
http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg358354.html

>From some of the earlier threads that I missed (below) I have the 
impression that the problem may be a very simple one, namely that starting 
with 2.6.22 one needs to run a command to enable SMART when a box is first 
booted -- the kernel no longer does this as part of the init/setup of the 
disks. But that is NOT consistent with the first two reports above, which 
show 'SMART ENABLED'.

Here are some of the earlier threads that I completely missed:

http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/0849.html
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg164863.html

Before I go off half-cocked, could anyone shed some light on this?  Is 
there a real problem here or just something dumb?

Cheers,
 	Bruce
