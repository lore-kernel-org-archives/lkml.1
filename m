Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZLTSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZLTSxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZLTSxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:53:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38949 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZLTSxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:53:23 -0500
Date: Sun, 20 Dec 2009 19:53:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: oleg@redhat.com, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: BKL use in ptrace
Message-ID: <20091220185318.GA15989@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

ptrace has this comment/BKL use:

        /*
         * This lock_kernel fixes a subtle race with suid exec
         */
        lock_kernel();

But unless I'm blind I don't see execve actually getting the BKL
anywhere. So is this comment outdated or misleading (is the race with exit?)
or is there a bug?

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
