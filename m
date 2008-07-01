Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYGAH30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYGAH30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYGAH3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:29:18 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:12027 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYGAH3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:29:17 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-37.messagelabs.com!1214897356!4065802!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 1 Jul 2008 09:29:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <linux-kernel@vger.kernel.org>
Subject: A minimally power-aware driver treats all messages as SUSPEND?
Message-ID: <20080701072911.GA6564@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 01 Jul 2008 07:29:12.0469 (UTC) FILETIME=[2891A450:01C8DB4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

include/linux/pm.h claims:

	A minimally power-aware driver treats all messages as SUSPEND
	[...].

This was introduced in commit 82bb67f2 by David Brownell.  At this time
PM_EVENT_HIBERNATE didn't exist.  This was added in 3a2d5b70 by Rafael
J. Wysocki without updating the above sentence.  I think a minimally
power-aware driver should treat all messages as HIBERNATE, shouldn't it?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
