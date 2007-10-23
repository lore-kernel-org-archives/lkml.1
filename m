Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXJWU4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXJWU4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXJWUz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:55:59 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:34479 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbXJWUz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:55:58 -0400
Message-Id: <20071023204843.442608289@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Tue, 23 Oct 2007 14:48:43 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Subject: [patch 0/2] RTC fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two fixes:

  - Minor bugfix on error path for mips.
  - If resource request fails, fall back to requesting only the
    ioports we actually use.  This is not a problem yet, but it
    will be if the PNP core claims resources before drivers attach.

--
