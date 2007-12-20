Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXLTFpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXLTFpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 00:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbXLTFp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 00:45:26 -0500
Received: from ozlabs.org ([203.10.76.45]:47582 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbXLTFpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 00:45:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-scsi@vger.kernel.org
Subject: [PATCH 0/5] sg_ring for scsi
Date: Thu, 20 Dec 2007 16:45:18 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Douglas Gilbert <dougg@torque.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201645.19035.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, some fixes since last time, as I wade through more SCSI drivers.  Some 
drivers use "use_sg" as a flag to know whether the request_buffer is a 
scatterlist: I don't need the counter, but I still need the flag, so I fixed 
that in a more intuitive way (an explicit ->sg pointer in the cmd).

Also, I've updated and tested scsi_debug, after Douglas's excellent 
suggestion.

(I just found out about struct scsi_pointer, so I'm off to update that now, 
too).

Cheers,
Rusty.
