Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZAVO0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZAVO0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZAVO0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:26:31 -0500
Received: from [202.81.31.148] ([202.81.31.148]:36845 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZAVO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:26:31 -0500
Date: Thu, 22 Jan 2009 19:26:40 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com,
       prasad@linux.vnet.ibm.com, naren@linux.vnet.ibm.com
Subject: [RFC Patch 0/9] Hardware Breakpoint interfaces - v4
Message-ID: <20090122135640.GA11161@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find the new set of patches that introduce kernel
interfaces to use Hardware Breakpoint registers and an implementation
for x86 (and x86_64) architecture, now labelled as Version IV.

The patches are based on 2.6.29-rc2 and have been tested to work fine on
x86 architecture. Some of the major changes over the previous version of
patches include:
i) A sample kernel module that uses Data Hardware breakpoint over a
kernel variable to monitor write operations. See
samples/hw_breakpoint/data_breakpoint.c.
ii) Changes in the register_kernel_hw_breakpoint() interface to accept
only one parameter - pointer to a 'hw_breakpoint' structure which will
contain all relevant data members.

Attempts to convert KGDB to use the proposed interfaces is stalled due
to an issue with KGDB (detailed here: http://tinyurl.com/aa9agy) and any
help from its maintainers will be gladly welcomed.

Pending any serious issues/comments, the next revision of patches will
be cleaved of the RFC tag and will be requested for inclusion.

Thanks,
K.Prasad

