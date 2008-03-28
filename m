Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYC1XKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYC1XKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbYC1XKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:10:19 -0400
Received: from mga05.intel.com ([192.55.52.89]:50614 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754525AbYC1XKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:10:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,572,1199692800"; 
   d="scan'208";a="541904206"
Message-ID: <47ED7832.5050702@linux.intel.com>
Date: Fri, 28 Mar 2008 15:58:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Oops/Warning report for the week of March 28th 2008
References: <47ED3F1A.1090101@linux.intel.com> <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org> <47ED7247.3020203@linux.intel.com>
In-Reply-To: <47ED7247.3020203@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Linus Torvalds wrote:
>>
>>> http://www.kerneloops.org/searchweek.php?search=input_release_device
>>
>> The problem with kerneloops is that it seems to be really hard to 
>> figure out the *source* of the oops. I can find the oopses (and it's 
>> really good with the whole search-and-clump-together-by-version 
>> thing), but then when some oops like this is found, it's hard to see 
>> where your kerneloops scripts found the oops from, so the context of 
>> the oops is all gone.

> I can try doing some sorting tricks in the grouping, so that those 
> oopses who have more data than this, show
> up on top... (and maybe a direct link on the search page)

I just implemented this; below are two examples of this:

http://www.kerneloops.org/searchweek.php?search=tcp_mark_head_lost
http://www.kerneloops.org/search.php?search=input_release_device

The ratio of automatic versus mailinglist/bugzilla mails is quite high in favor
of the automatic ones so there's not all THAT many of these at this point,
especially in the "searchweek" version, which only shows the last 7 days of
reports.
