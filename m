Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbXDYO4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbXDYO4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965620AbXDYO4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:56:17 -0400
Received: from gretel.pobox.com ([208.58.1.197]:60117 "EHLO gretel.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965589AbXDYO4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:56:16 -0400
X-Greylist: delayed 753 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 10:56:16 EDT
Message-ID: <462F68BF.5000805@hp.com>
Date: Wed, 25 Apr 2007 10:42:07 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@pobox.com
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/15] CFQ IO scheduler patch series
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using the patches posted yesterday 
(http://marc.info/?l=linux-kernel&m=117740312628325&w=2) here are some 
quick read results (as measured by iostat over a 5 minute period, taken 
in 6 second intervals) on a 4-way IA64 box with 42 disks (24 FC and 18 
U320), 42 processes (1 per disk) with 256 AIOs (16KB) outstanding at all 
times per device:

2.6.21-rc7:                                           1,006.023 MB/second
2.6.21-rc7 + new CFQ IO scheduler: 1,030.767 MB/second

showing about a 2.46% performance improvement with a 2.43% increase in 
%system used (3.738% -> 3.829%).

Interestingly enough this patch also seems to remove some noise during 
the run - see the chart at http://free.linux.hp.com/~adb/cfq/rkb_s.png

Alan D. Brunelle
HP / Open Source and Linux Organization / Scalability and Performance Group

