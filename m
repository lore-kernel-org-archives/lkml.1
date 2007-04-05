Return-Path: <linux-kernel-owner+w=401wt.eu-S1766696AbXDEQMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766696AbXDEQMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767131AbXDEQMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:12:01 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3333 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766696AbXDEQMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:12:00 -0400
Message-ID: <46151FCD.6000700@rtr.ca>
Date: Thu, 05 Apr 2007 12:11:57 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Chris Snook <csnook@redhat.com>, Paa Paa <paapaa125@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com> <4612852C.2030801@rtr.ca> <4612A854.1070702@cfl.rr.com> <4613C612.5040600@rtr.ca> <4615160A.4090506@cfl.rr.com>
In-Reply-To: <4615160A.4090506@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Mark Lord wrote:
>> This is mostly a problem with the WD Raptor drive, and some other WD 
>> drives.
>> I have not yet encountered/noticed the problem with other brands.
> 
> Sounds like this is a serious bug in the WD firmware.

For personal systems, yes.  For servers, probably not a bug.

Disabling readahead means faster execution queued commands,
since it doesn't have to "linger" and do unwanted read-ahead.
So this bug is a "feature" for random access servers.
And a big nuisance for everything else.

Cheers
