Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYIPPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYIPPm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYIPPmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:42:47 -0400
Received: from bu3sch.de ([62.75.166.246]:46859 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbYIPPmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:42:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Tue, 16 Sep 2008 17:42:15 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       John Linville <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>
References: <48CFC03A.8020708@lwfinger.net>
In-Reply-To: <48CFC03A.8020708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809161742.15527.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 16:18:34 Larry Finger wrote:
> Since commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f entitled
> "b43/b43legacy: add RFKILL_STATE_HARD_BLOCKED support", the radio LED
> no longer responds to rfkill switch events.
> 
> ATM, I do not have a fix, other than reversion of this commit.

It's kind of bogus that it pokes with the software rfkill state
from within the hardware rfkill handler.

Please revert this patch. The commit log says nothing about
why this is needed and I don't see a point in overriding the state
in the rfkill-private data structure from within the driver.

-- 
Greetings Michael.
