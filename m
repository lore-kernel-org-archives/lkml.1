Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371Ab0AHF7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0AHF7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127Ab0AHF7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:59:38 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:38234 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab0AHF7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:59:37 -0500
Date: Fri, 08 Jan 2010 00:59:28 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI/driver patch for Linux-2.6.33-rc3
Message-id: <alpine.LFD.2.00.1001080058020.4086@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
for a regression fix that I neglected to push for -rc2.

This will update the file shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.33/acpi-release-20091214-2.6.33-rc2.diff.gz

 drivers/platform/x86/hp-wmi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

through these commits:

Anisse Astier (1):
      hp-wmi: remove double free caused by merge conflict

with this log:

commit c9c041fcb1a4d69ed4791f00b57554eeb341d148
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 31 16:41:33 2009 +0100

    hp-wmi: remove double free caused by merge conflict
    
    Commit 3e9b988e4edf065d39c1343937f717319b1c1065
    "wmi: Free the allocated acpi objects through wmi_get_event_data"
    had the same purpose as commit
    44ef00e6482e755f36629773abc2aee83a6f53e3
    "hp-wmi: Fix two memleaks"
    
    This should solve this regression:
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14890
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
