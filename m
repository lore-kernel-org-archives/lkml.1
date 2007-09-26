Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbXIZTRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbXIZTRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXIZTRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:17:25 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:60102 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815AbXIZTRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:17:24 -0400
Date: Wed, 26 Sep 2007 15:17:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       randy.dunlap@oracle.com, hch@infradead.org
Subject: Re: [PATCH 0/3] A kernel tracing interface - (updated)
Message-ID: <20070926191721.GA6399@Krystal>
References: <1190830949.1232.11.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1190830949.1232.11.camel@lc4eb748232119.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:16:20 up 58 days, 19:35,  2 users,  load average: 0.62, 0.72, 0.60
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* David J. Wilder (dwilder@us.ibm.com) wrote:
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
> 
> Note: The following patches must be applied with 3/3.
> [patch 3/5] Add samples subdir
> 	http://lkml.org/lkml/2007/9/25/157

I guess you mean:
[patch 3/5] Add samples subdir (updated)
http://lkml.org/lkml/2007/9/25/366

(please try it with this new version, it should work as is..)

Mathieu

> [patch 4/5] Linux Kernel Markers - Samples
> 	http://lkml.org/lkml/2007/9/25/166
> 
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
