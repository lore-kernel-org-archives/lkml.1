Return-Path: <linux-kernel-owner+w=401wt.eu-S1030442AbXBLWyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030442AbXBLWyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030450AbXBLWyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:54:53 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:39621 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030442AbXBLWyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:54:52 -0500
Date: Mon, 12 Feb 2007 14:50:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org
Subject: build error: allnoconfig fails on mincore/swapper_space
Message-Id: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.20-git8 on x86_64:


  LD      init/built-in.o
  LD      .tmp_vmlinux1
mm/built-in.o: In function `sys_mincore':
(.text+0xe584): undefined reference to `swapper_space'
make: *** [.tmp_vmlinux1] Error 1

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
