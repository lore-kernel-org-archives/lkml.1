Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZDPGWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZDPGWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZDPGWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:22:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:48180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZDPGWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:22:36 -0400
Message-ID: <49E6CEA1.6090000@kernel.org>
Date: Thu, 16 Apr 2009 15:22:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, petkovbb@googlemail.com
Subject: Re: [block #for-next] block: clear req->errors on bio completion
 only  for fs requests
References: <49E671D8.1090002@kernel.org> <20090416061949.GQ5178@kernel.dk>
In-Reply-To: <20090416061949.GQ5178@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Apr 2009 06:22:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> Jens, can you please ack this patch?  With FUJITA's scsi_lib cleanup
>> and Borislav's patch to make ide not use preallocated data structures,
>> this is the only block bit which is necessary for ide cleanup
>> patchets.  If you're okay with it, I'd like to push this through
>> Bartlomiej's tree.
> 
> Sure, you can add my acked-by.

Thanks. :-)

-- 
tejun
