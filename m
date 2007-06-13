Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbXFMNwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbXFMNwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbXFMNvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:51:31 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:45813 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754887AbXFMNva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:51:30 -0400
Message-ID: <381742680.20643@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070613134902.132573123@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Wed, 13 Jun 2007 21:49:02 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ondemand readahead simplifications
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

These two patches makes the interface and data structure of ondemand readahead
more clear:

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
