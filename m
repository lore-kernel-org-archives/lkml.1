Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYJJIsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYJJIsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYJJIrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:47:24 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56992 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYJJIrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:47:19 -0400
X-AuditID: 0ac90650-aaac9ba000006fc9-f8-48ef16955876
Message-ID: <48EF168A.4000705@hitachi.com>
Date: Fri, 10 Oct 2008 17:47:06 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: tytso@mit.edu, adilger@sun.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/4] ext4/jbd2: possible filesystem corruption fixes
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set fixes ext4 fs corruption problems caused by
transient I/O error.  The ext3/jbd version is already in the
current -mm.

Here is the ext3/jbd version:
http://kerneltrap.org/mailarchive/linux-kernel/2008/7/24/2661724

This patch set consists of following 4 patches:

[PATCH 1/4] jbd2: abort when failed to log metadata buffers
[PATCH 2/4] jbd2: fix error handling for checkpoint io
[PATCH 3/4] ext4: add checks for errors from jbd2
[PATCH 4/4] jbd2: don't dirty original metadata buffer on abort

In the ext3/jbd version, PATCH 2/4 had a problem and I fixed it
with an additional patch later.  This time PATCH 2/4 includes
that fix.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


