Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXFNG25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXFNG25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXFNG2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:28:48 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53743 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751033AbXFNG2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:28:47 -0400
Message-ID: <381802490.31610@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070614062447.058708836@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 14 Jun 2007 14:21:19 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ondemand readahead simplifications
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

With the help from Rusty, the interface and data structure of ondemand
readahead are made more clear:

	readahead: split ondemand readahead interface into two functions
	readahead: sanify file_ra_state names

diffstat:
 fs/ext3/dir.c      |    4 -
 fs/ext4/dir.c      |    4 -
 fs/splice.c        |    6 -
 include/linux/fs.h |   61 +--------------
 include/linux/mm.h |   20 +++--
 mm/filemap.c       |   10 +-
 mm/readahead.c     |  165 +++++++++++++++++++++----------------------
 7 files changed, 116 insertions(+), 154 deletions(-)

Regards,
Fengguang
