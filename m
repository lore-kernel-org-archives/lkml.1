Return-Path: <linux-kernel-owner+w=401wt.eu-S1946351AbXBCFsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946351AbXBCFsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 00:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946353AbXBCFsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 00:48:24 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:49531 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946351AbXBCFsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 00:48:23 -0500
Date: Fri, 02 Feb 2007 23:48:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions with 2.6.20-rc5
In-reply-to: <20070203014215.GA28126@atjola.homenet>
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk, pomac@vapor.com,
       chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
Message-id: <45C4221E.7050201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.1kBz5luWz8nR0lLqm1VD4hZZYdw@ifi.uio.no>
 <fa.QZxgjxcwtENaZNY24NMTlKBSgIM@ifi.uio.no>
 <fa.fkPTbUGmKc/1pt0eD6TE4d02n+Q@ifi.uio.no>
 <fa.6iQt5OtHZ3x5w8eYbLxwULhLTJ0@ifi.uio.no>
 <fa.1aqo3IxNGJClHcBVZNTagX6bL9o@ifi.uio.no>
 <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no> <45B697D3.4070707@shaw.ca>
 <20070124003923.GA3093@atjola.homenet> <20070203014215.GA28126@atjola.homenet>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:
> On 2007.01.24 01:39:23 +0100, Björn Steinbrink wrote:
>> On 2007.01.23 17:18:43 -0600, Robert Hancock wrote:
>>> Larry Walton wrote:
>>>> The last patch (sata_nv-force-int-dev-in-interrupt.patch) 
>>>> seems to have fix the problem.  Much appreciated, 
>>>> thank you. I'd consider it a must have in 2.6.20.
>>> Can any of the rest of you that have been seeing this problem also 
>>> confirm that this fixes it?
>> Seems to work for me, uptime is about an hour now and no exception yet.
>> Had the stress test running for only about 10 minutes, but I usually got
>> an exception within an hour even during plain irssi usage, so I'm quite
>> confident that the patch fixes it.
> 
> Or maybe not :( Just got an exception on 2.6.20-rc6. Took 4 days of
> uptime to trigger, so it's just a lot harder to trigger now.

Same exception details as before?

There's a patch in -mm (sata_nv-use-adma-for-nodata-commands.patch) 
which should hopefully avoid this problem for the cache flush commands, 
at least - can you try that one out? You'll have to apply the other 
sata_nv patches in -mm first, i.e. this order:

http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2.patch
http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-use-adma-for-nodata-commands.patch

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

