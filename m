Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXFLDJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXFLDJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXFLDJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:09:24 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41366 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751983AbXFLDJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:09:20 -0400
Message-ID: <381617742.09716@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070612030450.590659600@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 12 Jun 2007 11:00:32 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] readahead update on splice reads
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The two patches optimizes readahead invocations in splice reads:

	readahead: move synchronous readahead call out of splice loop
	readahead: pass real splice size

They can be appended to readahead-convert-splice-invocations.patch in -mm tree.


diffstat:

 fs/splice.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Regards,
Fengguang
--
