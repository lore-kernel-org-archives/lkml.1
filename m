Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbXEOMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbXEOMli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbXEOMla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:41:30 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48419 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXEOMla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:41:30 -0400
Message-ID: <4649AA6C.2080808@sw.ru>
Date: Tue, 15 May 2007 16:41:16 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [patch i2o]  i2o layer cleanup 
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I've fixed a number of issues in i2o layer:
[patch i2o 1/6] i2o_cfg_passthru cleanup (memory leak and infinite loop)
[patch i2o 2/6] wrong memory access in i2o_block_device_lock()
[patch i2o 3/6] i2o message leak in i2o_msg_post_wait_mem()
[patch i2o 4/6] i2o proc reading oops
[patch i2o 5/6] i2o_proc files permission
[patch i2o 6/6] i2o debug output cleanup

However because of Markus Lidel is not i2o maintainer now, I do not understand
who should agree the following patches.

Thank you,
	Vasily Averin
