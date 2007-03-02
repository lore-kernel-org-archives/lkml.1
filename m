Return-Path: <linux-kernel-owner+w=401wt.eu-S1422721AbXCBCyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721AbXCBCyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422726AbXCBCyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:54:09 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53666 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422721AbXCBCyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:54:07 -0500
Date: Thu, 1 Mar 2007 18:53:48 -0800
Message-Id: <200703020253.l222rm5N009643@zach-dev.vmware.com>
Subject: [PATCH 0/9] Bugfix patches for i386/vmi/paravirt-ops
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 02 Mar 2007 02:54:04.0485 (UTC) FILETIME=[09DEEF50:01C75C76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, Linus, we have some critical bugfixes for the VMI paravirt-ops code.
Please apply.  If there are objections to certain pieces, they can be
reworked, but they are pretty much all needed for correctness.  We are
hoping to get these in the next 2.6.21-rc release.

We had quite a few difficulties debugging after the integration of the
hrtimers code, which is why this took so long.  Andrew, add you on
the list in case any further hrtimers integration issues pop up.

Thanks,

Zach
