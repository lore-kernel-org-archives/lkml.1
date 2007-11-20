Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbXKTKir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbXKTKir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXKTKij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:38:39 -0500
Received: from mail.univits.se ([212.247.11.167]:6742 "EHLO mail.univits.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbXKTKii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:38:38 -0500
X-Greylist: delayed 1417 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 05:38:38 EST
Message-ID: <4742B3A3.2050103@univits.com>
Date: Tue, 20 Nov 2007 11:14:59 +0100
From: =?ISO-8859-1?Q?Mikael_St=E5ldal?= 
	<mikael.staldal-ingen-reklam@univits.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Possibility to adjust the only-root-can-bind-to-port-under-1024 limit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux you have to be root in order to listen to TCP or UDP ports below 1024 (the 
well-known ports). As far as I know, this limit is hardcoded in the kernel.

In some cases, this limit do more harm than good, so it would be nice to be able to adjust it.

FreeBSD have a pair of sysctl parameters allowing you to adjust (or effectively remove) this 
  limit, net.inet.ip.portrange.reservedlow and net.inet.ip.portrange.reservedhigh. It would 
be nice if something similar to net.inet.ip.portrange.reservedhigh was implemented in Linux 
(with default value 1023).

I have no patch for this, since I have never done any kernel hacking before. But it seems 
like it should be easy to implement by replacing the PROT_SOCK constant with 
net.inet.ip.portrange.reservedhigh + 1.

(See my blog post for a more elaborate discussion about this:
http://www.staldal.nu/tech/2007/10/31/why-can-only-root-listen-to-ports-below-1024/)

/Mikael

