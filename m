Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXBAAPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXBAAPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXBAAPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:15:39 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:7406 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbXBAAPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:15:38 -0500
Date: Wed, 31 Jan 2007 18:14:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20-rc6 ramdisk problem
In-reply-to: <1170288386.29240.234.camel@localhost.localdomain>
To: tglx@linutronix.de
Cc: michal.k.k.piotrowski@gmail.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45C130DC.90905@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nr9vhGrVS5zmSNQEe1vQ/Ktii9w@ifi.uio.no>
 <45C12C3E.6010902@shaw.ca> <1170288386.29240.234.camel@localhost.localdomain>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 2007-01-31 at 17:54 -0600, Robert Hancock wrote:
>> I'm not sure if there's an inherent max ramdisk size limit, however I 
>> should point out that in most cases, using a tmpfs or ramfs file system 
>> is better than old-style ramdisks. Those filesystems return unused 
>> memory to the kernel (ramdisks statically allocate the entire space) and 
>> also avoid the filesystem overhead of ramdisks (the files are mapped 
>> into pagecache directly).
> 
> This is not a question of what's better or not. 
> 
> Michal stepped into a real life problem:
> 
> 1. ramdisk gets created in the first place w/o problems
> 2. formatting the same ramdisk succeeds
> 3. trying to use it fails
> 
> So either #1 or #2 should have failed in the first place. Failing in #3
> is definitely a BUG in #1 or #2.
> 
> How does your advise help to fix that BUG ? Ignoring it by using
> something else ?

Yes, there is likely a bug here of some sort. However, that doesn't 
change the fact that ramdisks are sub-optimal for most uses.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


