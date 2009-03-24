Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZCXPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZCXPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZCXPZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:25:10 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34459 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZCXPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:25:08 -0400
Date: Tue, 24 Mar 2009 20:54:35 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [Patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090324152435.GA17918@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and All,
		Please find the new patchset that addresses the comments to the
patch sent here: http://lkml.org/lkml/2009/3/19/430.

The patches are based on -tip tree commit
7ddd16604eb5fc54f8ac61d13be31e0f2c0a791e.

Changelog
---------
- Changes to load_debug_register(), unregister_kernel_hw_breakpoint() to address
  comments from the community.
- Re-arrangement of code in arch_register_kernel_hw_breakpoint(),
  arch_unregister_kernel_hw_breakpoint() and a new arch_load_debug_registers().
- Additional sanity checks in arch_check_va_in_<kernel/user>space().
- Removal of hbkpt_user_max variable and changes to variable names
- Address coding style issues and other minor fixes.

Kindly accept the patches to be a part of -tip tree.

Thanks,
K.Prasad

