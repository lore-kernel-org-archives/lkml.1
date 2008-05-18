Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYERMWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYERMWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbYERMNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:13:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58379 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbYERMNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:13:32 -0400
Cc: "Andi Kleen" <ak@suse.de>, "Andi Kleen" <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7wuznNhcUqC.A.xiH.EsBMIB@albercik>
Subject: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in powertop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 13:13:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10710
Subject		: [BISECTED] Lots of "rescheduling IPIs" in powertop
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-13 20:42 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
Handled-By	: Andi Kleen <andi@firstfloor.org>
		  Arjan van de Ven <arjan@infradead.org>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4


