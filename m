Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXIZSu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXIZSu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbXIZSuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:50:50 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:21302 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbXIZSuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:50:50 -0400
Date: Wed, 26 Sep 2007 11:41:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH 0/3] A kernel tracing interface - (updated)
Message-Id: <20070926114108.6ac77ce5.randy.dunlap@oracle.com>
In-Reply-To: <1190830949.1232.11.camel@lc4eb748232119.ibm.com>
References: <1190830949.1232.11.camel@lc4eb748232119.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 11:22:29 -0700 David J. Wilder wrote:

> These patches provide a kernel tracing interface called "trace".
> 
> (update) Moved the sample code to the new samples\ subdir
> 
> The motivation for "trace" is to:
> - Provide a simple set of tracing primitives that will utilize the high-
>   performance and low-overhead of relayfs for passing traces data from
>   kernel to user space.
> - Provide a common user interface for managing kernel traces.
> - Allow for binary as well as ascii trace data.
> - Incorporate features from the systemtap runtime that are
>   useful to others.
> 
> Patches are against 2.6.23-rc6-mm1
> 
> Summary of patches:
> [patch 1/3]  Trace code and documentation
> [patch 2/3]  Relay Reset Consumed
> [patch 3/3]  Trace sample
> 
> Note: Patches 1/3 and 2/3 must be applied together.

Patch 2 provides an interface that patch 1 needs, correct?
So yes, patches 1 & 2 need to be applied together (merged),
or their order could be reversed, yes?  Can't the Relay patch
be merged standalone without breaking anything?


> Note: The following patches must be applied with 3/3.
> [patch 3/5] Add samples subdir
> 	http://lkml.org/lkml/2007/9/25/157
> [patch 4/5] Linux Kernel Markers - Samples
> 	http://lkml.org/lkml/2007/9/25/166


---
~Randy
Phaedrus says that Quality is about caring.
