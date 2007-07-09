Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbXGIWJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbXGIWJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbXGIWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:08:52 -0400
Received: from wilma.widomaker.com ([204.17.220.5]:2264 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbXGIWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:08:51 -0400
Date: Mon, 9 Jul 2007 18:08:49 -0400
To: linux-kernel@vger.kernel.org
Subject: BUG: kernel crash report, odd...
Message-ID: <20070709220848.GA6782@widomaker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: shannon@widomaker.com (Charles Shannon Hendrix)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A system I was using a few minutes ago dumped this to the syslog:

Jul  9 17:50:38 daydream kernel: [76022.613000] BUG: unable to handle
kernel NUL
L pointer dereference at virtual address 00000010
Jul  9 17:50:38 daydream kernel: [76022.613000]  printing eip:
Jul  9 17:50:38 daydream kernel: [76022.613000] c01ace66
Jul  9 17:50:38 daydream kernel: [76022.613000] *pde = 00000000
Jul  9 17:50:38 daydream kernel: [76022.613000] Oops: 0000 [#1]


There was no other information either before or after.

What I saw was my KDE desktop stopped responding to events.

Machine didn't respond to power switch.

Unfortunately, that's all I know.

In the past when I had bugs like this, I got a fairly extensive kernel
error message, but this time the above is the only thing I saw.

I have not had kernel bugs like this until I started running 2.6.20 on a
new Kubuntu install.

Same hardware, but Slackware and my own custom 2.6.19 kernel never
crashed.

Is there anything I can do, in case this happens again, to try and
capture more information?

-- 
shannon           | An Irishman is never drunk as long as he can hold onto 
                  | one blade of grass and not fall off the face of the earth.
