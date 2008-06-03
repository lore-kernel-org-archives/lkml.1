Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbYFCStN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbYFCStN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYFCSsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:48:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:57946 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbYFCSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=DrFYya8d/3rUW6Rq+X4QN3ug5lHYShJCjh3NtFXiCx3rRtTKJ04kCnv6RN2JqCOJzepqJbzONxp7gtG8g9xzbrddIYhxkT6nEd2HCHFE9jTrtXGfOxHvIqFZ1evimG5z0y7CI12izGVc+jrId0vEXmMsAjWWpQkXhAgvisPTxUA=
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 22:46:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 0/2] x86 - nmi merging procedure fixes/cleanups
Message-ID: <48459206.0405560a.4d8f.22b3@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are few pacthes over tip/x86/nmi

commit 3d1ba1da2b4ff4ace7801e99fb9a3095b182d847
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 2 13:50:10 2008 +0200

    x86: fix nmi.c build bug

- fix incorrect nmi_watchdog assignment, clean the code a bit to eliminate a few #ifdef's
- code style cleanup/unification (seems to be _useless_ in functionallity since
  all checks are done by callers but you to decide)

 Please give them good testing (for me it works well on both 32/64 modes but under QEMU)

      		- Cyrill -
-- 
