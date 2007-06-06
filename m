Return-Path: <linux-kernel-owner+w=401wt.eu-S935867AbXFFVdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935867AbXFFVdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935012AbXFFVd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:33:27 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:50498 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934563AbXFFVdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:33:25 -0400
Subject: [RFC] [Patch 0/4] lock contention tracking slimmed down
From: Martin Peschke <mp3@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, jbaron@redhat.com, rostedt@goodmis.org,
       billh@gnuppy.monkey.org, mingo@elte.hu, linux-s390@vger.kernel.org
Content-Type: text/plain
Date: Wed, 06 Jun 2007 23:33:22 +0200
Message-Id: <1181165602.7133.18.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can save many lines of code in the lock contention tracking patches
by using some common code which implements statistics in a generic way.

Data is still gathered per cpu; output goes to debugfs files. Several
ideas that went into the lock contention tracking patches can be found
in the statistics infrastructure as well.

Please see the last patch for details and for some sample output.
The first three patches just prepare the statistics infrastructure
for this new use case.

Feel free to pick at any rough edge you want me to smooth out,
if you are interested in this approach.

[Patch 1/4] statistics: no include hell for users
[Patch 2/4] statistics: cleanups
[Patch 3/4] statistics: sets of statistics in single file
[Patch 4/4] lock contention tracking slimmed down

Please mind that the patches are against 2.6.22-rc3-mm1. They don't apply
against 2.6.22-rc4-mm1. (The statistics library functions have been dropped,
because a couple more users would be nice.)

Ah, and you might need to add CONFIG_STATISTICS to Kconfig of the
architecture of your choice (see s390).

Signed-off-by: Martin Peschke <mp3@de.ibm.com>


