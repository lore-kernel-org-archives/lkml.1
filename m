Return-Path: <linux-kernel-owner+w=401wt.eu-S968480AbXFHKQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968480AbXFHKQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965519AbXFHKQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:16:07 -0400
Received: from www.osadl.org ([213.239.205.134]:51223 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937197AbXFHKQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:16:06 -0400
Message-Id: <20070608101714.067427012@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 10:29:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Stable Team <stable@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch-stable 0/3] Futex fixes for stable 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

the following patch series is a backport of the futex fixups for stable.

Patch 1 and 2 are identical to the mainline version.

Patch 3 is a backport as there were other major changes in the futex code
in mainline. The design of the fixes is identical to the mainline version.

Should be applicable to 2.6.20 and earlier as well.

Please apply ASAP. The bugs in the futex code cause memory leaks and
kernel oopsen and are easily exploitable from user space.

Thanks,

	tglx

-- 

