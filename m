Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXCUSNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXCUSNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933305AbXCUSNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:13:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49965 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304AbXCUSNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:13:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46017557.1070405@s5r6.in-berlin.de>
Date: Wed, 21 Mar 2007 19:11:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       Thomas Meyer <thomas@m3y3r.de>, Tobias Diedrich <ranma@tdiedrich.de>
Subject: Re: [PATCH 2.6.21-rc4] ieee1394: fix oops on "modprobe -r ohci1394"
 after network class_device conversion
References: <200703140642.28390.ismail@pardus.org.tr> <200703150249.04169.ismail@pardus.org.tr> <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de> <200703210026.22825.ismail@pardus.org.tr>
In-Reply-To: <200703210026.22825.ismail@pardus.org.tr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ismail Dönmez wrote:
> On Tuesday 20 March 2007 23:43:22 Stefan Richter wrote:
...
>> +#if 0
>> +	/* FIXME - Is this the correct parent device anyway? */
>>  	SET_NETDEV_DEV(dev, &host->device);
>> +#endif
...
> This also fixes the issue for me,

Thanks for confirming this. I will sent the fix to Linus soon.
-- 
Stefan Richter
-=====-=-=== --== =-=-=
http://arcgraph.de/sr/
