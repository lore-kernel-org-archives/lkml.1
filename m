Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbZDIIye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbZDIIye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZDIIyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:54:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:34730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbZDIIyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:54:22 -0400
Message-Id: <20090409085342.799915215@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 10:53:42 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] perf_counter: fixes and an optimization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - fixes an off-by-one in string handling
 - fixes the mmap tracing to provide the full path
 - allows unpriviledged use of cpu counters
 - optimize mmap/comm tracing

-- 

