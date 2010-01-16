Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0APGqs (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 01:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240Ab0APGqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 01:46:46 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:54658 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0APGqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 01:46:45 -0500
Date: Sat, 16 Jan 2010 01:46:27 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Alexey Starikovskiy <aystarik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Xiaotian Feng <dfeng@redhat.com>, "Lin, Ming M" <ming.m.lin@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ACPICA: don't cond_resched() when irq_disabled or in_atomic
In-reply-to: <4911F71203A09E4D9981D27F9D83085840F38881@orsmsx503.amr.corp.intel.com>
Message-id: <alpine.LFD.2.00.1001160145090.10250@localhost.localdomain>
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
 <20091210100907.GA2446@ucw.cz> <4B2136D5.1030402@gmail.com>
 <20091210181800.GM19454@elf.ucw.cz> <4B214007.2080409@gmail.com>
 <4B217A2A.2040708@gmail.com>
 <4911F71203A09E4D9981D27F9D83085840F38881@orsmsx503.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Moore, Robert wrote:

> Let me know when you guys have finalized any changes to aclinux.h, and I will update this file in the base ACPICA code.

I think the v2 patch will go upstream.
Not super-critical to have ACPICA sync with Linux's aclinux.h,
since Linux has it already, but good hygine, I guess.

thanks,
-Len Brown, Intel Open Source Technology Center

