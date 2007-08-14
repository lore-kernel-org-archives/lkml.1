Return-Path: <linux-kernel-owner+w=401wt.eu-S935325AbXHNX3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935325AbXHNX3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935346AbXHNX1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:27:54 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:7241 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935110AbXHNX1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:27:52 -0400
Message-ID: <46C23A73.4090907@chelsio.com>
Date: Tue, 14 Aug 2007 16:27:47 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 5/13] cxgb3 - Expose HW memory page info
References: <20070811062954.8094.33064.stgit@speedy5> <46C14140.2000104@garzik.org>
In-Reply-To: <46C14140.2000104@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2007 23:26:30.0411 (UTC) FILETIME=[8B3C8DB0:01C7DECA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Divy Le Ray wrote:
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> Let the RDMA driver get HW page info to work around HW issues.
>> Assign explicit enum values.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>
> "HW issues" -- you need to go into far more detail, when adding a new 
> interface.  what hw issues?  why was this the best/only solution?
>
>

A HW issue requires limiting the receive window size to 23 pages of 
internal memory.
These pages can be configured to different sizes, thus the RDMA driver 
needs to know the
page size to enforce the upper limit.

Divy
