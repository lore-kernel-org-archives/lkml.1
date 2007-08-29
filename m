Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXH2Wpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXH2Wpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXH2WpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:45:22 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52846 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbXH2WpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:45:21 -0400
Message-ID: <46D5F6BF.2080607@linux.vnet.ibm.com>
Date: Thu, 30 Aug 2007 04:14:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
Subject: Re: [-mm PATCH]  Memory controller improve user interface
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop> <1188413148.28903.113.camel@localhost>  <46D5ED5C.9030405@linux.vnet.ibm.com> <1188425894.28903.140.camel@localhost>  <46D5F2BB.8010203@linux.vnet.ibm.com> <1188427000.28903.148.camel@localhost>
In-Reply-To: <1188427000.28903.148.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2007-08-30 at 03:57 +0530, Balbir Singh wrote:
>> True, mmap() is a good example of such an interface for developers, I
>> am not sure about system admins though.
>>
>> To quote Andrew
>> <quote>
>> Reporting tools could run getpagesize() and do the arithmetic, but we
>> generally try to avoid exposing PAGE_SIZE, HZ, etc to userspace in this
>> manner.
>> </quote>
> 
> Well, rounding to PAGE_SIZE exposes PAGE_SIZE as well, just in a
> non-intuitive fashion. :)
> 

Agreed, but the user might choose to ignore it altogether.

> If we're going to modify what the user specifies, we should probably at
> least mandate that writes are only a "suggestion" and users must read
> back the value to ensure what actually got committed.
> 

Agreed, excellent suggestion!

> If we're going to round in any direction, shouldn't we round up?  If a
> user specifies 4097 bytes and uses two pages, we don't want to complain
> when they hit that second page.  
> 

Absolutely, I used rounding to mean round up, truncation for rounding down.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
