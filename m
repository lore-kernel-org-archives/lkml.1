Return-Path: <linux-kernel-owner+w=401wt.eu-S1765858AbXJRQOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765858AbXJRQOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXJRQNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:13:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37385 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbXJRQNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:13:54 -0400
Date: Thu, 18 Oct 2007 21:55:13 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pbadari@us.ibm.com,
       dhaval@linux.vnet.ibm.com
Subject: Buggy idle time reported in /proc/uptime for SMP systems?
Message-ID: <20071018162513.GA19214@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The idle time reported in /proc/uptime (2nd field) seems to be the idle
time of only CPU0. Shouldn't it reflect the total idle time on a SMP system? 
Do folks agree that it is a bug that needs to be fixed? If so, will send
a patch ...

Fyi, I see patches submitted to fix this way back in 2001
[http://lkml.org/lkml/2001/3/17/55], but don't think they made in ..

-- 
Regards,
vatsa
