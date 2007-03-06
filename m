Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXCFHaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXCFHaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbXCFHaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:30:14 -0500
Received: from tag.witbe.net ([81.88.96.48]:52470 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbXCFHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:30:12 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Adrian Bunk'" <bunk@stusta.de>
Cc: <linux-kernel@vger.kernel.org>, "'David Brownell'" <david-b@pacbell.net>,
       <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>
Subject: RE: 2.6.21-rc2 : Oops in rtc_cmos...
Date: Tue, 6 Mar 2007 08:29:06 +0100
Organization: AS2917.net
Message-ID: <01b901c75fc1$2295d4c0$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070304234837.GE3441@stusta.de>
Thread-Index: Acdet6L/WEto3bhXSpGibStSiSsjBQBCSzhg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Adrian,

> does the patch in http://lkml.org/lkml/2007/2/23/184 fix your problem?

Yes, it does, so it's a Good One (tm), but I don't understand what's going
on then... My dmesg says, related to rtc :

...
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
pnp: Device 00:03 does not support disabling.
rtc_cmos: probe of 00:03 failed with error -16
...
and then later :
...
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
...

What does this all mean ? I thought an RTC Cmos was always there on a
standard PC motherboard... (that's why I had activated the option in the
first time).

Regards,
Paul

