Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbXKIV2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbXKIV2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXKIV22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:28:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbXKIV21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:28:27 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com
Subject: [PATCH 0/24] paravirt_ops for unified x86 - that's me again!
Date: Fri,  9 Nov 2007 16:42:41 -0200
Message-Id: <11946337851964-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

Here's a new spin of the pvops64 patch series.
We didn't get that many comments from the last time,
so it should be probably almost ready to get in. Heya!

>From the last version, the most notable changes are:
* consolidation of system.h, merging jeremy's comments about ordering
  concerns
* consolidation of smp functions that goes through smp_ops. They're sharing
  a bunch of code now.

Other than that, just some issues that arose from the rebase.

Please, not that this patch series _does not_ apply over linus git anymore,
but rather, over tglx cleanup series.

The first patch in this series is already on linus', but not on tglx', so
I'm sending it again, because you'll need it if you want to compile it
anyway.

tglx, in the absense of any outstanding NACKs, or any very big call for
improvements, could you please pull it in your tree?

Have fun,


