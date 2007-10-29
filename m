Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXJ2XTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXJ2XTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXJ2XTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:19:31 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:45502 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbXJ2XTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:19:30 -0400
From: Frans Pop <elendil@planet.nl>
To: balbir@linux.vnet.ibm.com
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Tue, 30 Oct 2007 00:19:27 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
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
Message-Id: <200710300019.28871.elendil@planet.nl>
X-OriginalArrivalTime: 29 Oct 2007 23:19:29.0428 (UTC) FILETIME=[27B4A540:01C81A82]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007, Balbir Singh wrote:
> We'll also need this additional patch (untested),

OK. Both patches together do the trick. Gave it a nice long test run and got 
no more weirdness.
Tested-by: Frans Pop <elendil@planet.nl>

> but in the long run I think the approach needs to be
>
> 1. Update stime and utime at the time of context switching -- keep it
>    in sync with p->sum_exec_runtime
> 2. Keep track of system/user context at system call entry points

Feel free to send me a patch for testing when you have one.

Cheers,
Frans
