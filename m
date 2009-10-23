Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZJWSZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZJWSZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZJWSZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:25:24 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:64456 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbZJWSZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:25:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAIeL4UpGGN1W/2dsb2JhbACBUNgqhD8EgV0
Date: Fri, 23 Oct 2009 14:25:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, David Wilder <dwilder@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: LTTng 0.164: LGPL v2.1 / GPL v2 relicensing phase 1
Message-ID: <20091023182527.GA15389@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:02:56 up 66 days,  4:52,  2 users,  load average: 0.46, 0.31,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The LTTng 0.164 release relicenses to dual LGPL v2.1 / GPL v2 license:

* tracer C files (1)
* tracer headers (1)
* immediate values C files (2)

And relicenses to dual BSD / GPL v2 license:

* immediate values headers (2)

(1) except include/linux/ltt-relay.h and ltt/ltt-relay-alloc.c, waiting
    for IBM approval for re-licensing code from kernel/relay.c to
    LGPLv2.1 / GPLv2 dual license.
(2) except sparc 64 support, waiting for approval from David S. Miller.

Phase 2 will also include the re-licensing of tracepoints, markers and
sparc64 immediate values as soon as we receive the approval from each
contributor involved (contacted in a different thread). We hope to also
receive approval from IBM to relicense the content of kernel/relay.c,
otherwise we will rewrite the parts we have used.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
