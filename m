Return-Path: <linux-kernel-owner+w=401wt.eu-S964855AbXCOAOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbXCOAOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbXCOAOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:14:30 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:42328 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855AbXCOAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:14:29 -0400
Message-ID: <45F88FC8.10202@s5r6.in-berlin.de>
Date: Thu, 15 Mar 2007 01:14:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: oops in __nodemgr_remove_host_dev (was Re: Ooops with suspend
 to RAM)
References: <200703140642.28390.ismail@pardus.org.tr> <200703141858.39531.ismail@pardus.org.tr> <45F83E14.3060003@s5r6.in-berlin.de> <200703150051.29945.ismail@pardus.org.tr> <45F88E8B.90403@s5r6.in-berlin.de>
In-Reply-To: <45F88E8B.90403@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> according to a quick test I made right now it is a regression post 2.6.20.
> # modprobe ohci1394   # wait a bit, eth1394 is auto-loaded
> # modprobe -r eth1394
> # modprobe -r ohci1394
> works.
> # modprobe ohci1394   # wait a bit, eth1394 is auto-loaded
> # modprobe -r ohci1394
> oopses with the same trace as Ismael posted. And indeed, looking at his
> trace once more I now also spot eth1394 among his linked-in modules.

To avoid any misunderstandings: Both the former and the latter sequence
work under 2.6.20 and earlier.
-- 
Stefan Richter
-=====-=-=== --== -====
http://arcgraph.de/sr/
