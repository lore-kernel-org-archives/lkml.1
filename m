Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYIPOSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYIPOSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYIPOSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:18:44 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:38559 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761AbYIPOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:18:43 -0400
Message-ID: <48CFC03A.8020708@lwfinger.net>
Date: Tue, 16 Sep 2008 09:18:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>, Michael Buesch <mb@bu3sch.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Adel Gadllah <adel.gadllah@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f entitled
"b43/b43legacy: add RFKILL_STATE_HARD_BLOCKED support", the radio LED
no longer responds to rfkill switch events.

ATM, I do not have a fix, other than reversion of this commit.

Larry

