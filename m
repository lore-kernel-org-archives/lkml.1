Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbXLNGLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbXLNGLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXLNGLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:11:25 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41636 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXLNGLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:11:24 -0500
From: Darren Hart <dvhltc@linux.vnet.ibm.com>
Reply-To: Darren Hart <dvhltc@us.ibm.com>
Organization: IBM Linux Technology Center
To: linux-rt-users@vger.kernel.org
Subject: Using CONFIG_FUNCTION_TRACE
Date: Thu, 13 Dec 2007 22:11:22 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "lkml, " <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712132211.23003.dvhltc@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to use CONFIG_FUNCTION_TRACE with the example trace-it.c in 
linux/scripts.  On both 2.6.23.9-rt13 and 2.6.24-rc2-rt1 the system 
slower becomes less responsive (measured by typing in ssh and a serial 
console) until after a couple minutes it doesn't respond to anything 
including sysrq, requiring a power cycle.

The trace-it.c program defaults to 10 seconds of tracing, I even tried 
dropping that to 100 us in case it just added so much overhead that 10 
seconds of idle turned into minutes.  But the 100us sleep hung too.

I tested on a 4 way (2x2) opteron.  

I enabled:

CONFIG_EVENT_TRACE
CONFIG_FUNCTION_TRACE

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
