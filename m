Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbXBKNPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbXBKNPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbXBKNPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:15:07 -0500
Received: from tag.witbe.net ([81.88.96.48]:44783 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbXBKNPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:15:06 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Benoit Boissinot'" <bboissin@gmail.com>, <rol@witbe.net>,
       "'Olaf Hering'" <olaf@aepfle.de>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.20/2.6.20-rc7 : ethX renumbered
Date: Sun, 11 Feb 2007 14:14:15 +0100
Organization: AS2917.net
Message-ID: <012001c74dde$87a16bd0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <40f323d00702110504i3a7b1421p9309eac1cfd75553@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdN3Sb0WA52hll5Ru6mIGWeM5Qj1QAARy2g
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Benoit,

> usually distro enable persistent interface naming with udev, check
> /etc/iftab and see if you have something like
> /etc/udev/something-iftab.rules

Found this :
# This file assigns persistent names to network interfaces.
# See iftab(5) for syntax.

eth0 mac 00:11:d8:a9:c0:c2 arp 1
ra0 mac 00:11:d8:b9:27:7e arp 1

As these are no MAC on my machine, I suspect this is the reason for the
renaming.

I'm trying Olaf's patch to check the message is printed, and next boot
is without this crap in this /etc/iftab file.

Regards,
Paul


