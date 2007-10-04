Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbXJDIQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbXJDIQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXJDIPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:15:49 -0400
Received: from cw.smartnet.de ([212.86.32.211]:44420 "HELO cw.smartnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751484AbXJDIPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:15:48 -0400
X-Greylist: delayed 704 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 04:15:48 EDT
Message-ID: <735D322AED9CD711BE53000476917CD002972934@NT-SERVER-5>
From: "Rustedt, Florian" <florian.rustedt@smartnet.de>
To: linux-kernel@vger.kernel.org
Subject: Root on drbd and /etc on a cd-rw: What do you think about that?
Date: Thu, 4 Oct 2007 10:09:14 +0200 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2653.19)
Content-Type: text/plain
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

As i want lvm on drbd and drbd for the whole disk, exclusive /boot, i needed
to find a way to keep two nearly identical /etc-directories.

This lead to the idea to put the /etc-directory on a cd-rw and let / be
handled completely via drbd/lvm.

Because the /etc-files are only read seldom, mostly only on startup, i don't
think, this is a real performance-impact, isn't it?

And a cd-rw delivers the possibility for me to make changes and safe them
again...

What do you think about that?

Another possibility would be using an USB-stick for each, but i had bad
experiences on some systems in activating usb 2.0 on startup, this was often
so slow, that the kernel "didn't find" the disk while booting...

Kind regards, Florian
**********************************************************************************************
IMPORTANT: The contents of this email and any attachments are confidential. They are intended for the 
named recipient(s) only.
If you have received this email in error, please notify the system manager or the sender immediately and do 
not disclose the contents to anyone or make copies thereof.
*** eSafe scanned this email for viruses, vandals, and malicious content. ***
**********************************************************************************************

