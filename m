Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbXLFS7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbXLFS7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXLFS7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:59:23 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49418 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXLFS7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:59:22 -0500
Message-ID: <47584672.8040201@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2007 00:28:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rsa@us.ibm.com, apw@shadowen.org, balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on powerpc
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com> <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com>
In-Reply-To: <20071206185006.GA21641@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

>> Why release the spinlock here? It's done after the count is incremented.
>> This patch does not seem correct.
> 
> Doh, you are correct, I'll make sure that I fix this up before applying
> it.
> 
> thanks,
> 
> greg k-h

Hi, Greg,

I ran some tests with the fixed up version of this patch and the system
fails to come up.

I see the WARN_ON in lib/kref.c:33 and the system fails to boot beyond
that point. I have not yet found time to debug it though.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
