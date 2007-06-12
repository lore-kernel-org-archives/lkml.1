Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbXFLHAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbXFLHAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXFLHAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:31 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13554 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbXFLHAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/18] Convert sendfile to splice
Date: Tue, 12 Jun 2007 08:57:56 +0200
Message-Id: <11816314942627-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of splice patches removes file_operations ->sendfile()
from the kernel and converts do_sendfile() to use ->splice_read()
to achieve the same function.

-- 
Jens Axboe


