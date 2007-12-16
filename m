Return-Path: <linux-kernel-owner+w=401wt.eu-S934286AbXLPMFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbXLPMFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934098AbXLPME3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:29 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60574 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934067AbXLPME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:26 -0500
Message-ID: <397806667.28507@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:28 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] mmap read-around and readahead
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are the mmap read-around related patches initiated by Linus.
They are for linux-2.6.24-rc4-mm1.  The one major new feature -
auto detection and early readahead for mmap sequential reads - runs
as expected on my desktop :-)


[PATCH 1/9] readahead: simplify readahead call scheme
[PATCH 2/9] readahead: clean up and simplify the code for filemap page fault readahead
[PATCH 3/9] readahead: auto detection of sequential mmap reads
[PATCH 4/9] readahead: quick startup on sequential mmap readahead
[PATCH 5/9] readahead: make ra_submit() non-static
[PATCH 6/9] readahead: save mmap read-around states in file_ra_state
[PATCH 7/9] readahead: remove unused do_page_cache_readahead()
[PATCH 8/9] readahead: move max_sane_readahead() calls into force_page_cache_readahead()
[PATCH 9/9] readahead: call max_sane_readahead() in ondemand_readahead()

Thank you,
Fengguang
-- 
