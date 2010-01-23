Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630Ab0AWT5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0AWT5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 14:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089Ab0AWT5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 14:57:46 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:54634 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0AWT5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 14:57:45 -0500
Date: Sat, 23 Jan 2010 14:57:28 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Christian Hofstaedtler <ch@zeha.at>
Cc: x86@kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-acpi@vger.kernel.org, venkatesh.pallipadi@intel.com,
       arjan@infradead.org, bruce.w.allan@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Default to ACPI reboots on newish X86 hardware
In-reply-to: <1264094323-7187-2-git-send-email-ch@zeha.at>
Message-id: <alpine.LFD.2.00.1001231455440.5156@localhost.localdomain>
References: <alpine.LFD.2.00.1001200007560.4265@localhost.localdomain>
 <1264094323-7187-1-git-send-email-ch@zeha.at>
 <1264094323-7187-2-git-send-email-ch@zeha.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,
I've replaced your previous patch in the acpi-test tree with this 
refreshed pair.

Note that the 2nd patch had some checkpatch issues.
Perhaps you can run checkpatch before sending future patches.

WARNING: braces {} are not necessary for single statement blocks
#35: FILE: arch/x86/kernel/reboot.c:464:
+	if (!dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL)) {
+		return 1;
+	}

WARNING: braces {} are not necessary for single statement blocks
#38: FILE: arch/x86/kernel/reboot.c:467:
+	if (year == 0) {
+		return 1;
+	}

WARNING: braces {} are not necessary for single statement blocks
#43: FILE: arch/x86/kernel/reboot.c:472:
+	if (year < 2003) {
+		return 0;
+	}

ERROR: Missing Signed-off-by: line(s)

total: 1 errors, 3 warnings, 47 lines checked


thanks,
Len Brown, Intel Open Source Technology Center

