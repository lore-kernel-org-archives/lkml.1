Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbXEJLlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbXEJLlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbXEJLlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:41:11 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4872 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbXEJLlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:41:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/12] Chaining sg lists for bio IO commands v4
Date: Thu, 10 May 2007 13:40:25 +0200
Message-Id: <11787972373654-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry to spam the list so quickly again, but v3 had a critical
bug that needs fixing. Changes since v3:

- Addressed Andrews review comments (thanks Andrew!)

- sg_next() grew a silly bug right before posting, where it would
  pass back the chain entry instead of the next one. Thanks to
  Benny Halevy for spotting that.

I didn't include the big drivers portion of the patch since it
hasn't changed, so grab that from the v3 posting.


