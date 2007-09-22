Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbXIVAtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbXIVAtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 20:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXIVAtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 20:49:09 -0400
Received: from highlandsun.propagation.net ([66.221.212.168]:4918 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082AbXIVAtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 20:49:08 -0400
Message-ID: <46F46603.8040208@symas.com>
Date: Fri, 21 Sep 2007 17:46:59 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9a8pre) Gecko/2007091708 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com> <20070922002717.GA16353@linux-os.sc.intel.com>
In-Reply-To: <20070922002717.GA16353@linux-os.sc.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> On Fri, Sep 14, 2007 at 09:33:30AM -0700, Howard Chu wrote:
>> So now I have this, which is pretty much
>> what
>> I wanted:
>>
>> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>> reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>> reg03: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>> reg04: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
>> reg05: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1
> 
> BTW, having overlapping WC, UC regions make the end result UC. So in this
> case, you may not be getting the desired performance.

Thanks, I noticed that later. I simply deleted the UC mapping since it was no 
longer needed.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP     http://www.openldap.org/project/
