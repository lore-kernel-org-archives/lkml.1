Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbXFLHHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbXFLHHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbXFLHGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:06:18 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17203 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759428AbXFLHGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:06:16 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/3] Splice network receive support
Date: Tue, 12 Jun 2007 09:03:57 +0200
Message-Id: <1181631840469-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches applies on top of the splice series just
posted. It implements basic network receive support, ie splicing
from a socket to a pipe.

There seems to be a skhead_buff_cache leak somewhere that I need
to track down, otherwise it works fine for me.

-- 
Jens Axboe


