Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZDVOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZDVOiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZDVOiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:38:46 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:60567 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbZDVOip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:38:45 -0400
Message-ID: <49EF2C32.4030409@opengridcomputing.com>
Date: Wed, 22 Apr 2009 09:39:46 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
References: <20090421184223.GP19637@balbir.in.ibm.com> <49EE42CC.7070002@opengridcomputing.com> <20090422131703.GO4593@kernel.dk> <49EF2882.1020306@opengridcomputing.com> <49EF293F.4030504@opengridcomputing.com>
In-Reply-To: <49EF293F.4030504@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> No there are a few patches applied that are heading upstream, but one 
>> is in the NFS RDMA server which isn't loaded yet and the rest are in 
>> iw_cxgb3 (iwarp driver) which also hasn't loaded at the time we 
>> crash. NOTE:  Out of 4 power cycles, one booted up ok, 3 hit the crash.
>>
>>
>>
>
> By the way, this one looks different from the last one I saw.  So its 
> not consistently crashing in the same spot.  The one I hit yesterday 
> (which I don't have the OOPs dump for was in rb_erase().
>
> Steve.

I'll start bisecting to isolate this.

Steve.
