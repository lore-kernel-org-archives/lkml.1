Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbZDHNGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbZDHNGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764902AbZDHNDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765335AbZDHNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:33 -0400
Message-Id: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/9] yet another batch of perf_counter patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - fixes an NMI race in the new context clock.
 - puts misc bits in the header
 - updates kerneltop
 - provides simple userspace profiling tools
 - provides PERF_RECORD_ADDR to record the data address that triggered
   the event (pagefaults only for now).


