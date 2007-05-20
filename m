Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXETUXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXETUXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXETUW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:22:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44259 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbXETUWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:22:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4650ADCC.90704@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 22:21:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Ismail D?nmez <ismail@pardus.org.tr>, Adrian Bunk <bunk@stusta.de>,
       Thomas Meyer <thomas@m3y3r.de>, Tobias Diedrich <ranma@tdiedrich.de>
Subject: Re: [PATCH 2.6.21-rc4] ieee1394: fix oops on "modprobe -r ohci1394"
 after network class_device conversion
References: <200703140642.28390.ismail@pardus.org.tr> <200703150051.29945.ismail@pardus.org.tr> <45F88E8B.90403@s5r6.in-berlin.de> <200703150249.04169.ismail@pardus.org.tr> <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de> <20070320233432.GA20228@kroah.com> <tkrat.f2e7e842cff5a275@s5r6.in-berlin.de> <4646F9F6.3040308@s5r6.in-berlin.de>
In-Reply-To: <4646F9F6.3040308@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I wrote on 2007-03-21:
>> On 20 Mar, Greg KH wrote:
>>> On Tue, Mar 20, 2007 at 10:43:22PM +0100, Stefan Richter wrote:
>>>>  	SET_MODULE_OWNER(dev);
>>>> +#if 0
>>>> +	/* FIXME - Is this the correct parent device anyway? */
>>>>  	SET_NETDEV_DEV(dev, &host->device);
>>>> +#endif
...
>>> If so, I guess this is ok for now as we can wait for the rewrite of the
>>> ieee1394 subsystem to get the linking done correctly :)
>> That's my hope too.
> 
> Alas there is some userspace breakage:
> https://bugs.gentoo.org/show_bug.cgi?id=177199

Greg, what about the ieee1394 class_device conversion patches you had in
the works?
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
