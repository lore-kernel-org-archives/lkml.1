Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbXIUWcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbXIUWcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXIUWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:31:59 -0400
Received: from ns2.suse.de ([195.135.220.15]:40431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbXIUWb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:31:59 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/50] x86 2.6.24 patches review II
Date: Sat, 22 Sep 2007 00:31:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- More cleanups and bug fixes
- Use CLFLUSH in c_p_a(). This were the patches that caused some trouble
in -mm with X11, but it should be hopefully fixed now (we'll see)
- Report all IPIs in /proc/interrupts (useful e.g. to find out why
CPU isolation fails) 
- Experimental patch to disable SVM for the clinical paranoid
- Dump the LER registers on Oopses by default (note that this is not 100%
reliable -- we know how to make it reliable, but that's not implemented yet)

Please review.

-Andi

