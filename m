Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbXLRWBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbXLRWBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXLRWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:01:44 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:31080 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756764AbXLRWBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:01:42 -0500
Message-ID: <47684342.3010807@cfl.rr.com>
Date: Tue, 18 Dec 2007 17:01:38 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: attempt to access beyond end of device
References: <4766BB17.10803@m3y3r.de> <4768400B.9090306@cfl.rr.com>
In-Reply-To: <4768400B.9090306@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2007 22:01:57.0081 (UTC) FILETIME=[9B585490:01C841C1]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15614.001
X-TM-AS-Result: No--9.151200-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, try that again with Jens' new address.

Phillip Susi wrote:
> Thomas Meyer wrote:
>> Hi,
>>
>> is somebody actually working on this bug?
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=9370
>>
>> I don't want to be impolite, but it's now more than a month since the
>> bug was opened.
>>
>> The bug still exists in v2.6.24-rc5-43-gda8cadb:
> 
> Have you tried simply removing the line mentioned in the bug report from 
> pktcdvd.c?
> 
> rq->cmd_type = REQ_TYPE_BLOCK_PC;
> 
> 
> Maybe Jens can comment on if that would be correct since he is more 
> familiar with the code than I.
> 

