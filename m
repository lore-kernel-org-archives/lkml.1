Return-Path: <linux-kernel-owner+w=401wt.eu-S1422692AbXDLFdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422692AbXDLFdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422673AbXDLFdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:33:11 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56035 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422692AbXDLFdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:33:10 -0400
Date: Wed, 11 Apr 2007 22:30:16 -0700
Message-Id: <200704120530.l3C5UGbv022814@zach-dev.vmware.com>
Subject: [PATCH 0/4] i386 - pte update optimizations
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some PTE optimizations for native and paravirt-ops kernels; this
provides a huge win for shadow mode hypervisors and gets rid of
some unnecessary atomic instructions in native kernels, saving
even more on UP by getting rid of implicit LOCK on xchg instruction.

Zach
