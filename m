Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYJTE03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYJTE03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYJTE0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:26:19 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53524 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYJTE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:26:18 -0400
X-AuditID: 0ac90650-aaac9ba000006fc9-2f-48fc0868da19
Message-ID: <48FC081D.60306@hitachi.com>
Date: Mon, 20 Oct 2008 13:25:01 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
       adilger@sun.com, jack@suse.cz, sandeen@redhat.com
Subject: status of the ext3/jbd error handling enhancement patches
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thank you for pushing my ext3/jbd to Linus.  But some of patches
in -mm (following three patches) haven't been sent to Linus.

  #jbd-fix-error-handling-for-checkpoint-io.patch: double-check this
  jbd-fix-error-handling-for-checkpoint-io.patch
  ext3-add-checks-for-errors-from-jbd.patch
  jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

They improve filesystem corruption problem and it is needed by
mission critical systems.

Could you tell me what is your concern (you commented, "double-check
this") ?  Are there something that I can help?  For example, I can
provide some SystemTap scripts to help tests.

Thank you,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


