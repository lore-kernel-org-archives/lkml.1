Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXKBNmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXKBNmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbXKBNmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:42:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49735 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbXKBNmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:42:13 -0400
Message-ID: <472B2908.7020507@linux.vnet.ibm.com>
Date: Fri, 02 Nov 2007 19:11:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: delayacct regression in 2.6.24 git
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

I missed commit 75d4ef16a6aa84f708188bada182315f80aab6fa
"sched: fix delay accounting performance regression"

Without these changes, I find that delay accounting does
not work as expected, I see zeros in the field for virtual,delay
and count(s).

CPU             count     real total  virtual total    delay total
                    0      535861848              0              0


This breaks existing delay accounting behaviour.

Am I missing something?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
