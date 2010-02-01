Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0BAE4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 23:56:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59524 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab0BAE4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:56:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B665EC9.6000608@jp.fujitsu.com>
Date: Mon, 01 Feb 2010 13:55:37 +0900
From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Peterson <martin.petersen@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>
CC: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH 0/2 v2] scsi: ftrace based scsi tracing feature
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v2 patch series of SCSI trace.

Changelog from v1:

 - fixed variable length command handling (DIF_TYPE2 case only)
 - moved scsi trace functions from kernel/trace/scsitrace.c to
   drivers/scsi/scsi_trace.c

Here are the links to the discussions on v1:

  [PATCH 0/2] scsi: ftrace based scsi tracing feature
    http://marc.info/?l=linux-scsi&m=126396981308416&w=2
  [PATCH 1/2] scsi: add __print_hex() to ftrace
    http://marc.info/?l=linux-scsi&m=126396984308451&w=2
  [PATCH 2/2] scsi: add scsi trace core function and put trace points
    http://marc.info/?l=linux-scsi&m=126396987608486&w=2

This patchset applies to 2.6.33-rc6.

Thanks,
Kei


