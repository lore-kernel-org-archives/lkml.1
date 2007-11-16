Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbXKPCcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbXKPCcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbXKPCcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:32:39 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50615 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbXKPCci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:32:38 -0500
Message-Id: <473D0156.3000203@mxs.nes.nec.co.jp>
Date: Fri, 16 Nov 2007 11:32:54 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH 0/5] vmcoreinfo patches for linux-2.6.24-rc3
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patchset is for the vmcoreinfo data.

The vmcoreinfo data has the minimum debugging information only
for dump filtering. makedumpfile (dump filtering command) gets
it to distinguish unnecessary pages, and makedumpfile creates
a small dumpfile.

[PATCH 1/5] Rename vmcoreinfo's macros returning the size
[PATCH 2/5] Use the existing offsetof() for VMCOREINFO_OFFSET()
[PATCH 3/5] Add "VMCOREINFO_" to all the call for vmcoreinfo_append_str()
[PATCH 4/5] Fix the configuration dependencies
[PATCH 5/5] Add the array length of "free_list" for filtering free pages

Patch 1-3 are cleanup patches, and they are the same as I sent before:
 http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0582.html
 http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html
 http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0586.html
Patch 4 is a new patch for fixing the configuration dependencies.
Patch 5 is a new patch for filtering free pages of linux-2.6.24.

Their details are explained in each patch.

I confirmed that their coding styles are right by checkpatch.pl and tested
them on my i386, x86_64 and ia64.


Thanks
Ken'ichi Ohmichi










