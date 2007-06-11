Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbXFLAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbXFLAT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXFLATt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:19:49 -0400
Received: from wilma.widomaker.com ([204.17.220.5]:3140 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXFLATs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:19:48 -0400
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 20:19:48 EDT
Message-ID: <466DE0F1.6080401@widomaker.com>
Date: Mon, 11 Jun 2007 19:55:29 -0400
From: Charles Shannon Hendrix <shannon@widomaker.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_nv adma issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


My system has issues running adma mode with sata_nv.  I have an nforce4 
motherboard.

What is the current status of this problem?

Is there any information I can provide to help debug it?

I gave up trying various fixes about 6 months ago, and put "sata_nv.adma=0" on 
the kernel command line in LILO, and that fixed the problem.

However, recently I changed distributions and went back to 2.6.20 (kubuntu 7.04).

This kernel says that sata_nv.adma=0 is an invalid kernel option.

I'm pretty puzzled by that, because it is supposed to disable adma mode in the 
sata_nv driver.

/proc/cmdline says:

root=<hash> ro sata_nv.adma=0 quiet splash

...so it seems I did give the parameter properly.

Any ideas appreciated.

Is there a better way to deal with this?

Also, one more: does it hurt to wait until the sata_nv driver fails a few 
times (at which point it stops bitching) and use the machine?  Once it
fails about 6 times, I no longer have any issues, and speed is still good 
enough to use until a real fix can be had.

Thanks.



-- 
shannon           | An Irishman is never drunk as long as he can hold onto
                   | one blade of grass and not fall off the face of the earth.
