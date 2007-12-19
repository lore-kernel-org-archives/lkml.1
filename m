Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbXLSGbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbXLSGbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 01:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXLSGbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 01:31:37 -0500
Received: from ozlabs.org ([203.10.76.45]:46645 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbXLSGbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 01:31:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Wed, 19 Dec 2007 17:31:26 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712191731.26512.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the start of my attempt to simplify and make explicit
the chained scatterlist logic.

It's not complete: my SATA box boots and seems happy, but all the other
users of SCSI need to be updated and checked.  But I've gotten far enough
to believe it's worth persuing.

Cheers,
Rusty.
