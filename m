Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbXJ3F4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbXJ3F4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXJ3F4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:56:43 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:12760 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbXJ3F4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:56:43 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Tue, 30 Oct 2007 06:56:38 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710122231.50739.elendil@planet.nl> <20071029200425.GA830@elte.hu> <20071029214321.GA25669@linux.vnet.ibm.com>
In-Reply-To: <20071029214321.GA25669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710300656.38220.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Oktober 2007 schrieb Balbir Singh:
> We'll also need this additional patch (untested), but in the long run
> I think the approach needs to be
> 
> 1. Update stime and utime at the time of context switching -- keep it
>    in sync with p->sum_exec_runtime
> 2. Keep track of system/user context at system call entry points

This is similar to what s390 and ppc64 do when CONFIG_VIRT_CPU_ACCOUNTING is 
set. Whenever you do a patch, please make sure to not break the already 
precise values for utime and stime on s390 and ppc. Feel free to CC me 
whenever you have a patch for this.

Christian
