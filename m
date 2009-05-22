Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZEVJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZEVJQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZEVJQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:16:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36812 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZEVJQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:16:40 -0400
Date: Fri, 22 May 2009 11:22:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@Sun.COM>,
       Michael Ellerman <michaele@au1.ibm.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090522092245.GC846@one.firstfloor.org>
References: <20090519142416.356254359@linux.vnet.ibm.com> <20090519142418.583158351@linux.vnet.ibm.com> <20090519150031.GA21271@elte.hu> <4A16686C.7060800@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A16686C.7060800@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Back when kernel_execve() used to be called execve(), this function was 
> required to prevent linker errors. If it's generally agreed not to name 
> kernel functions execve(), this one might as well be removed (not sure 
> about such an agreement though).

I think we can safely assume now that nothing in the kernel will
be named execve.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
