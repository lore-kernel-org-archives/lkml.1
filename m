Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbXIZSWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbXIZSWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbXIZSWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:22:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60319 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbXIZSWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:22:39 -0400
Subject: [PATCH 0/3] A kernel tracing interface - (updated)
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, randy.dunlap@oracle.com, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca
Content-Type: text/plain
Date: Wed, 26 Sep 2007 11:22:29 -0700
Message-Id: <1190830949.1232.11.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches provide a kernel tracing interface called "trace".

(update) Moved the sample code to the new samples\ subdir

The motivation for "trace" is to:
- Provide a simple set of tracing primitives that will utilize the high-
  performance and low-overhead of relayfs for passing traces data from
  kernel to user space.
- Provide a common user interface for managing kernel traces.
- Allow for binary as well as ascii trace data.
- Incorporate features from the systemtap runtime that are
  useful to others.

Patches are against 2.6.23-rc6-mm1

Summary of patches:
[patch 1/3]  Trace code and documentation
[patch 2/3]  Relay Reset Consumed
[patch 3/3]  Trace sample

Note: Patches 1/3 and 2/3 must be applied together.

Note: The following patches must be applied with 3/3.
[patch 3/5] Add samples subdir
	http://lkml.org/lkml/2007/9/25/157
[patch 4/5] Linux Kernel Markers - Samples
	http://lkml.org/lkml/2007/9/25/166

Signed-off-by: David Wilder <dwilder@us.ibm.com>


