Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbXIKMC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbXIKMC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbXIKMCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:02:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763651AbXIKMCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:02:11 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070911202.911586000@suse.de>
To: torvalds@osdl.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.23] [0/3] More last minute bug fixes for x86
Date: Tue, 11 Sep 2007 14:02:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Some more x86 bug fixes for .23rc6

- Fix the infamous "5 minutes" vdso problem on 32bit HPET with new glibc
- Error handling fix in cpuid4 handling (Jan Beulich) 
- Fix leak of ../kernel out of build dir (Ben LaHaise & Sam Ravnborg) 

Please merge.

-Andi
