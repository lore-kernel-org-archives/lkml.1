Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXFNPZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXFNPZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXFNPZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:25:35 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51055
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbXFNPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:25:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 2] seccomp updates
Message-Id: <patchbomb.1181833733@v2.random>
Date: Thu, 14 Jun 2007 17:08:53 +0200
From: Andrea Arcangeli <andrea@cpushare.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Those are two longstanding updates for seccomp that I need applied ASAP.

It's not the first time I submit them, hope they go in this time, for the
happiness of all the anti-seccomp and in turn anti-cpushare folks out there.

1) this reduces the number of bytes that seccomp takes when enabled (in ram
   terms)
2) this makes seccomp absolutely zerocost at runtime (in cpu terms, even for
   the scheduler and not only for the syscalls)

As soon as the money is allowed in (and no it's not a technical problem
anymore, the code is completely finished and tested in the sandbox since two
weeks ago), the userland package may become a bit more spread than only in
debian, and I hardcoded those prctl in the userland side, so I wouldn't like
breakage to spread if somebody registers those prctl numbers in the kernel for
something else.

Thanks.
