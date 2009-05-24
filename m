Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZEXIZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZEXIZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 04:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZEXIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 04:25:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37640 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZEXIZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 04:25:17 -0400
X-IronPort-AV: E=Sophos;i="4.41,239,1241409600"; 
   d="scan'208";a="52391700"
Subject: Re: [PATCH] perf_counter: do not create perf counter mlock sysctl
 when CONFIG_PERF_COUNTERS=n
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
In-Reply-To: <20090522192510.GB18651@elte.hu>
References: <1242985373.22654.225.camel@zakaz.uk.xensource.com>
	 <20090522192510.GB18651@elte.hu>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Sun, 24 May 2009 09:25:16 +0100
Message-ID: <1243153516.26568.41.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 15:25 -0400, Ingo Molnar wrote:
> * Ian Campbell <Ian.Campbell@citrix.com> wrote:
> 
> > Building tip from 82811bee3 without CONFIG_PERF_COUNTERS results in:
> > 
> >   CC      kernel/sysctl.o
> > kernel/sysctl.c:928: error: 'sysctl_perf_counter_mlock' undeclared here (not in a function)

> Hm, is this still needed? It doesnt apply here and i'm not seeing 
> build failures.

Looks like I was using an obsolete branch, on current tip (790dc57b) it
was already fixed by the commit which added the first perf counter
sysctl in 1ccd1549.

Ian.

