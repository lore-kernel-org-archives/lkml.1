Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0BOJfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:35:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41066 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0BOJfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:35:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B7914CD.8020508@jp.fujitsu.com>
Date: Mon, 15 Feb 2010 18:33:01 +0900
From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH 0/2 v3] scsi: ftrace based scsi tracing feature
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v3 patch series of SCSI trace.  Since there has been no
more new feedback on v2 for about a week, I've decided to post
this.

Changelog from v2:

  - fixed variable length command handling (removed the
    assumption that READ/WRITE(32) is only called if protection
    is enabled.)

Here are the links to the discussions on v2:

  [PATCH 0/2 v2] scsi: ftrace based scsi tracing feature
    http://marc.info/?l=linux-scsi&m=126500018231317&w=2
  [PATCH 1/2 v2] scsi: add __print_hex() to ftrace
    http://marc.info/?l=linux-scsi&m=126500074718183&w=2
  [PATCH 2/2 v2] scsi: add scsi trace core function and put trace
points
    http://marc.info/?l=linux-scsi&m=126500087718320&w=2

This patchset applies to 2.6.33-rc8.

Thanks,
Kei

