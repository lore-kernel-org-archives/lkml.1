Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbXIFPAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbXIFPAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbXIFO7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:59:54 -0400
Received: from mail.suse.de ([195.135.220.2]:33267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbXIFO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:59:53 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070906459.839970000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH for 2.6.23] [0/3] Last minute x86 bug fixes for 2.6.23
Date: Thu,  6 Sep 2007 16:59:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Don't use CLFLUSH for text patching because it breaks on some VIA CPUs.
- Fix NMI watchdog testing hang on i386
- Fix perfctr NMI watchdog on Yonah

-Andi
