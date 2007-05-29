Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXE2Wir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXE2Wir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXE2Wig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:38:36 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:32639 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXE2Wif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:38:35 -0400
Message-ID: <465CAB5D.7060405@chelsio.com>
Date: Tue, 29 May 2007 15:38:21 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 4/7 RESEND] cxgb3 - Update FW to 4.1
References: <20070526231748.12319.20729.stgit@localhost.localdomain> <465B5A8B.7000701@garzik.org>
In-Reply-To: <465B5A8B.7000701@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2007 22:38:03.0227 (UTC) FILETIME=[049CBAB0:01C7A242]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> divy@chelsio.com wrote:
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> Bump FW version to 4.1.
>> Modify chip tuning in consequence.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>> ---
>>
>>  drivers/net/cxgb3/regs.h    |    4 ++++
>>  drivers/net/cxgb3/t3_hw.c   |   40 
>> ++++++++++++++++++++++------------------
>>  drivers/net/cxgb3/version.h |    2 +-
>>  3 files changed, 27 insertions(+), 19 deletions(-)
>
> You think requiring a FIRMWARE UPGRADE is something that should be 
> done in the middle of a kernel bugfix series?  What Q/A planet are you 
> from?

I made a bad jugdement.
I'll repost a patch series for 2.6.22 fixes against Linus'tree, and a 
patch series for driver improvements against netdev-2.6#upstream, if it 
is acceptable.

>
> This is a completely ridiculous burden you are placing on the 
> individual user.  A good driver knows that firmware NOT SHIPPED WITH 
> THE KERNEL does not necessarily move in lock-step with the kernel driver.

We're actively working on RDMA improvements, leading to these FW updates.
Some of the changes are unfortunately not backward compatible, hence the 
exact matching the driver enforces.
The bundle driver/FW is getting finalized. New adapters will be shipped 
with the right image once it is available.
In the mean time, this is indeed a burden for the current users to get 
the corresponding FW.

Divy

