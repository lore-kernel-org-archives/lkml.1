Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbXBDItq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbXBDItq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 03:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXBDItq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 03:49:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbXBDItp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 03:49:45 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070204063707.23659.20741.sendpatchset@linux.site>
Subject: [patch 0/9] buffered write deadlock fix
Date: Sun,  4 Feb 2007 09:49:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Have fixed a few issues since last time:
- better comments for the SetPageUptodate race
- actually fix the nobh problem rather than adding a comment
- use kmap_atomic instead of kmap

Patches against 2.6.20-rc7.

Thanks,
Nick

--
SuSE Labs

