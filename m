Return-Path: <linux-kernel-owner+w=401wt.eu-S1761369AbXH2WiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369AbXH2WiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbXH2WiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:38:18 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55566 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbXH2WiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:38:17 -0400
Message-ID: <46D5F517.1080809@linux.vnet.ibm.com>
Date: Thu, 30 Aug 2007 04:07:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [-mm PATCH] Memory controller improve user interface
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop> <1188413148.28903.113.camel@localhost>  <46D5ED5C.9030405@linux.vnet.ibm.com> <1188425894.28903.140.camel@localhost> <6599ad830708291520t2bc9ea20m2bdcd9e042b3a423@mail.gmail.com> <1188426352.28903.143.camel@localhost>
In-Reply-To: <1188426352.28903.143.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2007-08-29 at 15:20 -0700, Paul Menage wrote:
>> I'd argue that having the user's specified limit be truncated to the
>> page size is less confusing than giving an EINVAL if it's not page
>> aligned.
> 
> Do we truncate mmap() values to the nearest page so to not confuse the
> user? ;)
> 

I think rounding to the closest page size is a better option, but
again it can be a bit confusing. I am all for using memparse() to
parse the user input as a specification of the memory limit.

The second question of how to store it internally without truncation/
rounding is something we need to agree upon. We also need to see
how to display the data back to the user.

I chose kilobytes for two reasons

1. Several people recommended it
2. Herbert mentioned that they've moved to that interface and it
   was working fine for them.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

PS: I am going off to the web to search for some CUI/CLI guidelines.
