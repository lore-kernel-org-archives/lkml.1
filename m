Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbXHYGcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbXHYGcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXHYGcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 02:32:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37184 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbXHYGcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 02:32:01 -0400
Message-ID: <46CFCCDF.9060101@garzik.org>
Date: Sat, 25 Aug 2007 02:31:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.23 RESEND] cxgb3 - Fix dev->priv usage
References: <20070823220628.9835.73819.stgit@speedy5> <46CFA8E8.90101@garzik.org>
In-Reply-To: <46CFA8E8.90101@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Divy Le Ray wrote:
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> cxgb3 used netdev_priv() and dev->priv for different purposes.
>> In 2.6.23, netdev_priv() == dev->priv, cxgb3 needs a fix.
>> This patch is a partial backport of Dave Miller's changes in the 
>> net-2.6.24 git branch.
>> Without this fix, cxgb3 crashes on 2.6.23.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>> ---
>>
>>  drivers/net/cxgb3/adapter.h       |   10 +++
>>  drivers/net/cxgb3/cxgb3_main.c    |  126 
>> +++++++++++++++++++++----------------
>>  drivers/net/cxgb3/cxgb3_offload.c |    6 +-
>>  drivers/net/cxgb3/sge.c           |   23 ++++---
>>  drivers/net/cxgb3/t3cdev.h        |    3 -
>>  5 files changed, 100 insertions(+), 68 deletions(-)
>>
> 
> applied

I take that back.  Rejected -- it breaks infiniband build.

