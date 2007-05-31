Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbXEaEKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbXEaEKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXEaEK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:10:26 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:10271 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbXEaEKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:10:25 -0400
Message-ID: <465E4AA9.70706@chelsio.com>
Date: Wed, 30 May 2007 21:10:17 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/7] cxgb3 - Fix SGE page management
References: <20070526225947.12097.82363.stgit@localhost.localdomain> <465B58DE.1010308@garzik.org>
In-Reply-To: <465B58DE.1010308@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2007 04:09:59.0436 (UTC) FILETIME=[8E02CCC0:01C7A339]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> divy@chelsio.com wrote:
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> Streamline page management on RX.
>> Fix dma mappings.
>>
>
> NAK #2:  You should use the page_address(page) accessor rather than 
> creating a struct member in the same struct as your page, solely to 
> contain the virtual address.
Jeff,

The struct member caches the value of page_address(page) + current 
offset for optimization purposes.

Divy

