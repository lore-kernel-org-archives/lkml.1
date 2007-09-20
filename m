Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXITMSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXITMSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXITMSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:18:36 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37689 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXITMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:18:34 -0400
Message-ID: <46F264F1.30301@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2007 17:47:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Guillaume Chazarain <guichaz@yahoo.fr>, Jonathan Lim <jlim@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>,
       Michael Neuling <mikey@neuling.org>
Subject: Re: Add all thread stats for TASKSTATS_CMD_ATTR_TGID (v5)
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com> <46D7C23F.7020509@linux.vnet.ibm.com> <20070831143535.2e4709c7@localhost.localdomain> <20070912171816.f0993440.akpm@linux-foundation.org> <20070915204239.4a6af65e@localhost.localdomain> <20070918002339.4a989377@localhost.localdomain> <20070919232054.77c271aa.akpm@linux-foundation.org> <46F23550.6050209@linux.vnet.ibm.com> <20070920121601.GA135@tv-sign.ru>
In-Reply-To: <20070920121601.GA135@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Andrew,
>>
>> Thanks for reviewing the patchset, this patch is on my review and test
>> queue (which has gotten rather long of late). I'll test it further and
>> get back.
> 
> I still think this version is very wrong. It makes the ->signal->stats
> absolutely meaningless. Quoting myself:
> 


Hi, Oleg,

Yes, I see, removing the memcpy is definitely wrong. Thanks for catching
it. I did not get a chance to review the patch, it's on my review queue,
but since you've reviewed it, I am very glad that you have and
identified potential issues.

Big Thanks!

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
