Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYLEWbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYLEWbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYLEWbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:31:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:58156 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756894AbYLEWbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:31:05 -0500
X-Authenticated: #527675
X-Provags-ID: V01U2FsdGVkX1/mRuMDPWzmlmPbJwbzugIaELpbMkgvXVHertAQg5
	WUFCheYvOZ816D
Message-ID: <4939ABA5.4090402@gmx.de>
Date: Fri, 05 Dec 2008 23:31:01 +0100
From: Reinhard Nissl <rnissl@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.17) Gecko/20080922 SUSE/2.0.0.17-0.1 Thunderbird/2.0.0.17 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ERROR: Unidentified device type 0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got the ASUS P6T WS Professional mainboard including Marvell
88SE6320 SAS controller and attached a single Seagate 10k6 SAS
harddrive to the first SAS port.

Installation of openSUSE 11.1rc1 went well but after rebooting,
the harddrive doesn't get found. When the initrd script loads the
mvsas module, the following output appears on screen:

sas: phy-10:1 added to port-10:0, phy_mask:0x2 (             0)
ERROR: Unidentified device type 0

I first tried to install openSUSE 11.0 but the installer didn't
find the harddrive. If I recall correctly, it was for the same
reason as it is now when trying to boot the 11.1rc1 system.

So I think, there exists already a fix for this issue, as the
11.1rc1 installer sees the drive, which is still missing in the
initrd environment.

I really would like to help solving this issue, but I need a
pointer where and how to start digging. I've started a openSUSE
bug (https://bugzilla.novell.com/show_bug.cgi?id=450302, Bug
450302 - mvsas doesn't find SAS drive anymore after installation)
almost a week ago but didn't get much help there.

I'd really appreciate some help to get the new system running.
Thanks in advance.

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de
