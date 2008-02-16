Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbYBPVt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbYBPVt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 16:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbYBPVtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 16:49:19 -0500
Received: from serenity.mcc.ac.uk ([130.88.200.93]:64853 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYBPVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 16:49:18 -0500
Message-ID: <47B75ABB.8000005@gentoo.org>
Date: Sat, 16 Feb 2008 21:50:51 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20080212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
CC: linux kernel list <linux-kernel@vger.kernel.org>, matthew@wil.cx,
       andreas.eckstein@gmx.net, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: pci-disable-decoding-during-sizing-of-bars.patch no longer needed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch titled pci-disable-decoding-during-sizing-of-bars.patch in -mm 
was previously used as a candidate to fix a boot hang with Intel's Q35 
chipset: https://bugs.gentoo.org/show_bug.cgi?id=198810

However, that particular issue is solved by commit a0ca9909609 in Linus 
tree:
	PCI x86: always use conf1 to access config space below 256 bytes

So unless there are other reasons for keeping 
pci-disable-decoding-during-sizing-of-bars around, I think we can drop it.

Thanks,
Daniel
