Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYL2FOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYL2FOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 00:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYL2FO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 00:14:26 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:33398 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbYL2FOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 00:14:25 -0500
Message-ID: <49585CA7.7020406@lwfinger.net>
Date: Sun, 28 Dec 2008 23:14:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Julienne Hill <jmhill@anl.gov>
Subject: Re: [ANNOUNCE] ndiswrapper 1.54 for Linux 2.6.28 Released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Sat, 27 Dec 2008 12:05:57 MST, jmerkey@xxxxxxxxxxxxxxxxxxxxx said:

> And most, if not all, of the reverse engineered and hacked firmware is
> **SHIT** and does not work properly. My bcml15.sys drivers work great --
> the Linux drivers with the crap firmware which locks up all the time and
> stops receiving packets does not even make the LED wireless display work.

The firmware used by the b43 driver for BCM43XX is _EXACTLY_ the same as used by
the Windows drivers. We are working on reverse-engineering the firmware, but
that is not workiong yet. In fact, the firmware is extracted from the Broadcom
drivers. If the firmware is faulty, it isn't our fault. Of course, our RE is not
perfect, but then we get absolutely no support from the vendor.

Your device may work better with ndiswrapper and bcmwl5.sys than with b43, but I
find that ndiswrapper dies after about 4 hours and cannot be resurrected even by
unloading and reloading the driver. A reboot is needed. On the other hand, b43
just keeps on chugging.

Larry
