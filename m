Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYKVPcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYKVPcZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 10:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbYKVPcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 10:32:14 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33295 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758267AbYKVPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 10:32:13 -0500
Message-ID: <492825F8.6020606@lwfinger.net>
Date: Sat, 22 Nov 2008 09:32:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Yuval Hager <yuval@avramzon.net>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
Subject: Re: BCM4312 Fails when xdm is started
References: <200811151801.02369.yuval@avramzon.net> <4926FDB3.2030701@lwfinger.net> <200811220839.32674.yuval@avramzon.net> <200811221613.00303.mb@bu3sch.de>
In-Reply-To: <200811221613.00303.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:

> Somebody disabled MMIO and busmastering.
> And somebody cleared the CACHE_LINE_SIZE register.

Are these all the read/write bits in the configuration area? Should I conclude
that someone zeroed this area?

In case the kernel memory diagnostics don't help, is there any way to trap
writes to the configuration registers?

Larry
