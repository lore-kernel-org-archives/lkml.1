Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbXF3THm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbXF3THm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXF3THf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:07:35 -0400
Received: from r6cu202.net.upc.cz ([89.176.98.202]:2960 "EHLO slunatko.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751012AbXF3THe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:07:34 -0400
X-Greylist: delayed 37596 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jun 2007 15:07:34 EDT
Message-ID: <4686170D.2090105@suse.cz>
Date: Sat, 30 Jun 2007 10:40:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070301 SUSE/1.0.9-1.1 SeaMonkey/1.0.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Jason Wessel <jason.wessel@windriver.com>, paulus@samba.org,
       xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, xfs@oss.sgi.com
Subject: Re: 2.6.22-rc6-mm1
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>	<200706291432.10128.m.kozlowski@tuxland.pl> <20070629134748.71adba1e.akpm@linux-foundation.org>
In-Reply-To: <20070629134748.71adba1e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 29 Jun 2007 14:32:09 +0200
> Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
>> anyway after unselecting XMON we can see:
>>
>>   CC [M]  fs/xfs/linux-2.6/xfs_ioctl32.o
>> fs/xfs/linux-2.6/xfs_ioctl32.c: In function 'xfs_ioc_bulkstat_compat':
>> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: 'xfs_inumbers_fmt_compat' 
>> undeclared (first use in this function)
>> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared identifier is 
>> reported only once
>> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appears in.)
>> make[2]: *** [fs/xfs/linux-2.6/xfs_ioctl32.o] Blad 1
>> make[1]: *** [fs/xfs] Blad 2
> 
> Michal cc'ed.  I think this is the one which was already reported but
> I haven't seen a fix yet?

Hi, I sent you an updated patch yesterday (should I've changed the
subject / started a new thread? This was my first patch so bear with
me... :)). Anyway, the mail with the fix is here:
http://lkml.org/lkml/2007/6/29/87

Michal
