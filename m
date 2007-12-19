Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbXLSAoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbXLSAoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXLSAoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:44:38 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45548 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbXLSAoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:44:37 -0500
Date: Tue, 18 Dec 2007 18:43:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Out of memory and no killable processes: 2.6.22-2-686-bigmem
In-reply-to: <fa.oSel00y9Hn5hvV3laxPiw9blEfU@ifi.uio.no>
To: Nico Schottelius <nico-kernel-20071219@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <4768692A.3030204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.oSel00y9Hn5hvV3laxPiw9blEfU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nico Schottelius wrote:
> Hello!
> 
> We are running Debian with 2.6.22-2-686-bigmem on Dell Blade 1955 hardware
> and get a Kernel Panic with oom + message that there are no processes
> left to kill:
> 
> http://home.schottelius.org/~nico/unix/linux/oom_no_killable-2.6.22-1.jpeg
> 
> Anyone an idea, what's the cause for that? This error happened on two of
> those machines,
> 
> What I can see in our analysis done with munin is that the number of
> open inodes and inode table size decreased within some days from 40k
> to next to zero. Munin uses
> 
>    awk '{print "used.value " $1-$2 "\nmax.value " $1}' < /proc/sys/fs/inode-nr
> 
> to log those value (happened on both machines).
> 
> Thanks for any hint and CC as usual, please.

How much RAM is in these machines? If you're running tons of memory, it 
really is better to run a 64-bit kernel if possible. I believe there are 
some cases where low memory can be pretty easily exhausted on machines 
with lots of high memory.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

