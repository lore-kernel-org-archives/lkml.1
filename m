Return-Path: <linux-kernel-owner+w=401wt.eu-S1761216AbXH2W23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216AbXH2W23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbXH2W2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:28:21 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:55890 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383AbXH2W2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:28:20 -0400
Message-ID: <46D5F2BB.8010203@linux.vnet.ibm.com>
Date: Thu, 30 Aug 2007 03:57:07 +0530
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
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop> <1188413148.28903.113.camel@localhost>  <46D5ED5C.9030405@linux.vnet.ibm.com> <1188425894.28903.140.camel@localhost>
In-Reply-To: <1188425894.28903.140.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2007-08-30 at 03:34 +0530, Balbir Singh wrote:
>> I've thought about this before. The problem is that a user could
>> set his limit to 10000 bytes, but would then see the usage and
>> limit round to the closest page boundary. This can be confusing
>> to a user. 
> 
> True, but we're lying if we allow a user to set their limit there,
> because we can't actually enforce a limit at 8,192 bytes vs 10,000.
> They're the same limit as far as the kernel is concerned.
> 
> Why not just -EINVAL if the value isn't page-aligned?  There are plenty
> of interfaces in the kernel that require userspace to know the page
> size, so this shouldn't be too difficult.

True, mmap() is a good example of such an interface for developers, I
am not sure about system admins though.

To quote Andrew
<quote>
Reporting tools could run getpagesize() and do the arithmetic, but we
generally try to avoid exposing PAGE_SIZE, HZ, etc to userspace in this
manner.
</quote>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
