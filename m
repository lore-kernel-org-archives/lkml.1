Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZLZTmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZLZTmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 14:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZLZTmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 14:42:17 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:49667 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZLZTmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 14:42:16 -0500
Date: Sat, 26 Dec 2009 14:42:02 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI: WMI: Handle duplicate GUIDs
In-reply-to: <200912261914.59515.carlos@strangeworlds.co.uk>
Message-id: <alpine.LFD.2.00.0912261440290.4089@localhost.localdomain>
References: <4B352513.90302@lwfinger.net>
 <200912261836.41882.carlos@strangeworlds.co.uk>
 <4B365E56.9030302@lwfinger.net> <200912261914.59515.carlos@strangeworlds.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi-test, after satisfying checkpatch's brace-foo below.

thanks,
Len Brown, Intel Open Source Technology Center

ERROR: open brace '{' following function declarations go on the next line
#34: FILE: drivers/platform/x86/wmi.c:719:
+static bool guid_already_parsed(const char *guid_string) {

WARNING: braces {} are not necessary for single statement blocks
#43: FILE: drivers/platform/x86/wmi.c:728:
+		if (strncmp(gblock->guid, guid_string, 16) == 0) {
+			return true;
+		}

total: 1 errors, 1 warnings, 48 lines checked

