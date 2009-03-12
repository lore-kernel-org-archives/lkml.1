Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZCLC1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZCLC1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZCLC1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:27:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:50816 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZCLC1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:27:22 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org, norsk5@yahoo.com
Subject: [v3 PATCH 0/2] Correct AMD8111 EDAC drivers
Date: Thu, 12 Mar 2009 10:14:02 +0800
Message-Id: <1236824044-20579-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 12 Mar 2009 02:26:47.0621 (UTC) FILETIME=[FE520F50:01C9A2B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Doug and Andrew,

This the latest v3 patches for EDAC AMD8111 driver. I have integrated two minor changes in amd8111_edac.[ch] respectively, and all the rest 5 patches in v2 series just remain the same.

In amd8111_edac.h, I have removed the const qualifier from amd8111_dev_info.ctl_name, to eliminate a gcc warning about discarding qualifier; in amd8111_edac.c, I have replaced the including of <linux/io.h> with <asm/io.h>, because on powerpc, __do_inb() and __do_outb() are actually defined nowhere but "arch/powerpc/include/asm", despite this would incur a warning from checkpatch.pl.

Best regards,

Harry
