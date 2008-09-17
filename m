Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYIQCwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYIQCwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 22:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYIQCwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 22:52:15 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37138 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYIQCwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 22:52:14 -0400
Message-ID: <48D070DC.80007@lwfinger.net>
Date: Tue, 16 Sep 2008 21:52:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net> <200809162018.28548.carlos@strangeworlds.co.uk> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org> <20080917023334.GA1187@khazad-dum.debian.net>
In-Reply-To: <20080917023334.GA1187@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> However, rfkill_force_state() is NOT updating LED states (I just checked).
> I will sleep on the issue, and send in a patch tomorrow.
> 
> This probably means a small patch to rfkill + Matthew's fixed patch to use
> rfkill_force_state() in b43 will fix the regression in the right way.
> 
> I don't care either way which kind of fix goes to 2.6.27, though.
> 
> The proper fix for rfkill will be in two stages. A small fix now, and a
> complete change on the LED handling to use the blocking notifier chain
> instead later on (which will clean up rfkill code somewhat).
> 

I do not dispute that rfkill-handling in b43 is broken; however, prior
to the commit in question, it worked.

I also think we can agree that we need to get it working before 2.6.27
is released. If the small fix now is the reversion of bc19d6e, then I
think this is the correct path. We will then have a couple of weeks to
get the code working correctly before the 2.6.28 merge starts.

I admit that I never tested any of the RFKILL patches as they went in.
One of the reasons is that the development process seemed rather
untidy to an outsider, and I wasn't sure that any of the code would
ever be in the kernel. As such, it snuck up on me. I'll not let that
happen again. After the reversion, I will again test any suggested
code changes, but do not expect me to work out any of the changes. I
have enough to do.

Larry

