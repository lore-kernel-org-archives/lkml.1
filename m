Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZGULek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZGULek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZGULej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:34:39 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:49516 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZGULei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:34:38 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: NOHZ: local_softirq_pending 80
Date: Tue, 21 Jul 2009 13:34:36 +0200
Message-ID: <87my6yclrn.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

               Hi!

A couple of days ago a system of ours running 2.6.30-rc6 (sorry)
logged this:

Jul 18 06:31:03 noc2b kernel: [5057094.000050] NOHZ: local_softirq_pending 80

I don't know about anything special happening that time, maybe some
daily cronjob was still running.  The machine went on without a hitch,
so I report this mainly as a data point.  It's HRTIMER_SOFTIRQ, if I
read interrupt.h correctly.  It's the only occasion I ever met such a
message.
-- 
Regards,
Feri.
