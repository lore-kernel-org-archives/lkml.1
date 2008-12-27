Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYL0JYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYL0JYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYL0JXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:23:47 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:34843 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbYL0JXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:23:45 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Dec 2008 04:23:45 EST
From: "Tigran Grigoryan" <tigrangr@synopsys.COM>
To: <linux-kernel@vger.kernel.org>
Cc: "'Tigran Grigoryan'" <tigrangr@synopsys.COM>
Subject: usb_create_hcd calls dev_set_drvdata
Date: Sat, 27 Dec 2008 13:15:59 +0400
Message-ID: <006501c96803$bb2f4e40$318deac0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcloA7dp0z0qMIwEQt2n2HCF1A6+Eg==
Content-Language: en-us
x-cr-puzzleid: {83D539FC-CD8C-4E5F-A1A1-E7212C43A282}
x-cr-hashedpuzzle: BJqT KGge KNK5 LCbf LFAe MOFj MWhT O34p QRV4 SXAp SoOR UD/I VmHw Vthf WLjm WblY;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAaQBnAHIAYQBuAGcAcgBAAHMAeQBuAG8AcABzAHkAcwAuAGMAbwBtAA==;Sosha1_v1;7;{83D539FC-CD8C-4E5F-A1A1-E7212C43A282};dABpAGcAcgBhAG4AZwByAEAAcwB5AG4AbwBwAHMAeQBzAC4AYwBvAG0A;Sat, 27 Dec 2008 09:15:52 GMT;dQBzAGIAXwBjAHIAZQBhAHQAZQBfAGgAYwBkACAAYwBhAGwAbABzACAAZABlAHYAXwBzAGUAdABfAGQAcgB2AGQAYQB0AGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Why usb_create_hcd calls dev_set_drvdata and never uses that data.
OTG device drivers may want to set their own data.

Thanks,
Tigran

