Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXCNS0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXCNS0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbXCNS0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:26:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49468 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbXCNS0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:26:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45F83E14.3060003@s5r6.in-berlin.de>
Date: Wed, 14 Mar 2007 19:25:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: oops in __nodemgr_remove_host_dev (was Re: Ooops with suspend
 to RAM)
References: <200703140642.28390.ismail@pardus.org.tr> <45F7D922.6010501@s5r6.in-berlin.de> <200703141858.39531.ismail@pardus.org.tr>
In-Reply-To: <200703141858.39531.ismail@pardus.org.tr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ismail Dönmez wrote:
> On Wednesday 14 March 2007 13:14:42 Stefan Richter wrote:
>> Do you have a script or config which marks the
>> ohci1394 module to be unloaded before suspend?  
> 
> I used kpowersave to suspend, I failed to find anything related to ohci1394 in 
> its config but rmmod ohci1394 gives exact oops so it must be rmmoding it. 
[...]
> Are you able to rmmod it?

Yes, but on 2.6.20 and earlier kernels, most of the time with
development versions of the 1394 drivers. I still haven't tried
2.6.21-rc, will hopefully get to it tonight.

[...]
> I'll give -mm a try sometime this weekend then.

It will most certainly behave the same, unless you use the new
alternative FireWire drivers which are a whole different game. I hate to
say it but they don't have suspend + resume support yet. Like the
vanilla Linux drivers before 2.6.20/21, they have to be unloaded before
suspend or at least reloaded after resume.
-- 
Stefan Richter
-=====-=-=== --== -===-
http://arcgraph.de/sr/
