Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZIZSLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZIZSLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZIZSLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:11:46 -0400
Received: from mta-14.siol.net ([193.189.160.142]:55788 "EHLO mta-14.siol.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbZIZSLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:11:45 -0400
X-Greylist: delayed 2287 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2009 14:11:45 EDT
Date: Sat, 26 Sep 2009 19:33:36 +0200
From: "Darko K." <darko.koruga@siol.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31 crash when resuming from hibernation
Message-ID: <20090926193336.3e3a8985@beavis.confused.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Kqeii1zdLlh04CkSln.u3kn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Kqeii1zdLlh04CkSln.u3kn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I've just experienced a kernel crash when resuming from hibernation
(suspend to disk). System was still operational so I was able to gather
dmesg output before rebooting the machine (dmesg output is attached
to this mail). This is first time this has happened with 2.6.31. I was
getting occasional crash when resuming from hibernation with 2.6.28.4
although I was never able to capture dmesg output as machine was just
frozen, I could not even ping it.

My hardware is:
- Intel G41 chipset
- 2GB RAM
- Intel Pentium E5200

System has been running for a few days with at least one hibernation
per day (sometimes more) and one suspend to RAM (for testing purposes).
/usr/sbin/s2disk is used to put system into hibernation.

OS is Debian testing running kernel 2.6.31, X.Org 1.6.3. Intel
video driver 2.8.1.

I am not subscribed to lkml so please put me on cc: if you reply to this
mail.

Regards,
              Darko
--MP_/Kqeii1zdLlh04CkSln.u3kn
Content-Type: application/x-gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=dmesg.txt.gz

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
i0MnCrnw6QsA2n8AbiJJL+M7AAA=

--MP_/Kqeii1zdLlh04CkSln.u3kn--
