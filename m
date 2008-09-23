Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYIWSnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYIWSnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYIWSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:43:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35352 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYIWSn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:43:26 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: agk@sourceware.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: [PATCH] dm: Add support for data integrity to DM
Date: Tue, 23 Sep 2008 14:41:10 -0400
Message-Id: <1222195272-18674-1-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080920211433.9e1a6872.akpm@linux-foundation.org>
References: <20080920211433.9e1a6872.akpm@linux-foundation.org>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Sorry about the delayed response.  I'm still on the road after LPC.

Andrew> For better or for worse, the developers of dm.c have chosen to
Andrew> keep the whole file presentable in an 80-col display.  This
Andrew> patch breaks that, and they might not like this.

I've broken the lines.


[Excessive BUG_ONs]

Andrew> This will provide no more information than the oops which will
Andrew> happen two lines later.

Debugging debris.  Gone.


>> +struct request_queue *dm_queue(struct mapped_device *md)
>> +{
>> +    return md->queue;
>> +}

Andrew> This (unused, undocumented) function should be inlined.

 - It's not unused.

 - return md->queue is more descriptive than anything I could possibly
   put in a comment.

 - None of the other accessor functions in DM are inlined.  I'll let
   Alasdair decide.

Updated patches follow.

-- 
Martin K. Petersen      Oracle Linux Engineering
