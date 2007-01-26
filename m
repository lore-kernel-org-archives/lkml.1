Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXAZPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXAZPz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965697AbXAZPz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:55:29 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42272 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965692AbXAZPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:55:28 -0500
Message-ID: <45BA246B.6030505@lwfinger.net>
Date: Fri, 26 Jan 2007 09:55:23 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: roucaries bastien <roucaries.bastien@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: Bcm43xx oops after suspend to disk
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net> <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com>
In-Reply-To: <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

roucaries bastien wrote:
>> Do you have the log stuff that precedes this part? In particular, was
>> there a assertion that failed?
>>
> It is oops on resume and no asseertion failled this boot. However I
> have usually a lot of
> bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
> drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()

Those are well known and do not affect this problem.

> Moreover after the first oops I have a second oops (Surelly a
> consequence of the first).

I think that is right.

Unfortunately, I cannot test for this problem on my system as it doesn't suspend at all.

Does this oops happen every time, or is it intermittent? I'm looking at the code to find places to
insert debugging statements. At present, I don't understand how it gets to the shutdown code while
resuming!

Larry


