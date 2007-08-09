Return-Path: <linux-kernel-owner+w=401wt.eu-S939638AbXHIMmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939638AbXHIMmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939621AbXHIMla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:34944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939614AbXHIMl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:29 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070809241.425881000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/12] x86 Late merge bug fixes for 2.6.23
Date: Thu,  9 Aug 2007 14:41:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Various simple bug fixes, no new features. Please review.
I plan to send them to Linus later.

I don't have anything else critical pending. If you believe
a x86 patch is critical and really needs to make .23 please send email.

There are a few hardware fixes pending too, but they're not regressions
so probably .24 material.

Open problems:
- Still one known reference counting bug in c_p_a()
- x86-64 vdso compilation still broken on old debian binutils
* No satisfactionary workaround found so far. Those users might need to update
their binutils


-Andi


