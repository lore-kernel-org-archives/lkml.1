Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbXE1IKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbXE1IKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXE1IKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:10:03 -0400
Received: from neopsis.com ([213.239.204.14]:49471 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752091AbXE1IKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:10:01 -0400
Message-ID: <465A9410.5060606@dbservice.com>
Date: Mon, 28 May 2007 10:34:24 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: at mm/slab.c:777 __find_general_cachep()
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.367,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.22-rc2-g47b97135, happened while running wine (32bit app) on
my amd64 box... should I try -rc3?

BUG: at mm/slab.c:777 __find_general_cachep()

Call Trace:
 [<ffffffff80278146>] __kmalloc+0xa6/0xe0
 [<ffffffff802ac959>] compat_core_sys_select+0x109/0x290
 [<ffffffff802ae3f1>] compat_sys_select+0xe1/0x190
 [<ffffffff8021e124>] cstar_do_call+0x1b/0x65


tom
