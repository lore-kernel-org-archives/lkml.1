Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbXLQSIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbXLQSIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXLQSIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:08:41 -0500
Received: from www17.your-server.de ([213.133.104.17]:50979 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXLQSIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:08:40 -0500
Message-ID: <4766BB17.10803@m3y3r.de>
Date: Mon, 17 Dec 2007 19:08:23 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: attempt to access beyond end of device
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is somebody actually working on this bug?

http://bugzilla.kernel.org/show_bug.cgi?id=9370

I don't want to be impolite, but it's now more than a month since the
bug was opened.

The bug still exists in v2.6.24-rc5-43-gda8cadb:

ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
attempt to access beyond end of device
sr0: rw=0, want=54852, limit=40944
Buffer I/O error on device sr0, logical block 13712
attempt to access beyond end of device
sr0: rw=0, want=54856, limit=40944
Buffer I/O error on device sr0, logical block 13713
attempt to access beyond end of device
sr0: rw=0, want=54860, limit=40944
Buffer I/O error on device sr0, logical block 13714
attempt to access beyond end of device
sr0: rw=0, want=54864, limit=40944
Buffer I/O error on device sr0, logical block 13715
attempt to access beyond end of device
sr0: rw=0, want=54868, limit=40944
Buffer I/O error on device sr0, logical block 13716
attempt to access beyond end of device
sr0: rw=0, want=54872, limit=40944
Buffer I/O error on device sr0, logical block 13717
attempt to access beyond end of device
sr0: rw=0, want=54876, limit=40944
Buffer I/O error on device sr0, logical block 13718
attempt to access beyond end of device
sr0: rw=0, want=54880, limit=40944
Buffer I/O error on device sr0, logical block 13719
attempt to access beyond end of device
sr0: rw=0, want=54852, limit=40944
Buffer I/O error on device sr0, logical block 13712
attempt to access beyond end of device
sr0: rw=0, want=54856, limit=40944
Buffer I/O error on device sr0, logical block 13713

mfg
thomas
