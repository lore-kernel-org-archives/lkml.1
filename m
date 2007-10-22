Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbXJVR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbXJVR3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXJVR3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:29:34 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:58535 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXJVR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:29:33 -0400
To: akpm@linux-foundation.org, mingo@elte.hu, jdike@addtoit.com
CC: linux-kernel@vger.kernel.org
Subject: futex strangeness in 2.6.23-mm1/UML
Message-Id: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 22 Oct 2007 19:29:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a process stuck in pthread_rwlock_wrlock(), even though it
looks like the lock is not held by anybody.

I think the last -mm was OK.  Any ideas?

If not, I'll go searching for the offending patch.

Thanks,
Miklos
