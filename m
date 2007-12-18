Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbXLRVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbXLRVsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXLRVsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:48:02 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:30776 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750700AbXLRVsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:48:00 -0500
Message-ID: <4768400B.9090306@cfl.rr.com>
Date: Tue, 18 Dec 2007 16:47:55 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@suse.de>
Subject: Re: BUG: attempt to access beyond end of device
References: <4766BB17.10803@m3y3r.de>
In-Reply-To: <4766BB17.10803@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2007 21:48:13.0196 (UTC) FILETIME=[B04574C0:01C841BF]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15614.000
X-TM-AS-Result: No--7.775100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Hi,
> 
> is somebody actually working on this bug?
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9370
> 
> I don't want to be impolite, but it's now more than a month since the
> bug was opened.
> 
> The bug still exists in v2.6.24-rc5-43-gda8cadb:

Have you tried simply removing the line mentioned in the bug report from 
pktcdvd.c?

rq->cmd_type = REQ_TYPE_BLOCK_PC;


Maybe Jens can comment on if that would be correct since he is more 
familiar with the code than I.
