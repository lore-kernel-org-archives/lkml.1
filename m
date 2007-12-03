Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXLCNs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXLCNs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXLCNst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:48:49 -0500
Received: from probity.mcc.ac.uk ([130.88.200.94]:50548 "EHLO
	probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbXLCNss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:48:48 -0500
Message-ID: <47540950.4090207@gentoo.org>
Date: Mon, 03 Dec 2007 13:49:04 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
References: <200712031419.41596.toralf.foerster@gmx.de>
In-Reply-To: <200712031419.41596.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Today I tried to hibernate my ThinkPad but got the following :

And the outcome was what exactly? It didn't suspend, and hard-hung? Or 
didn't suspend, came back to a usable system? ...

> Dec  3 14:14:29 n22 c420 00000000 
> Dec  3 14:14:29 n22 dca29fb8 dca29f90 d30ad4c4 0851bf48 0851bf48 0851bfcb dca29fb8 c01036f1 
> Dec  3 14:14:29 n22 Call Trace:
> Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
> Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
> Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
> Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
> Dec  3 14:14:29 n22 [<c01c109d>] rb_erase+0x15d/0x280
> Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
> Dec  3 14:14:29 n22 [<c028031b>] schedule+0x13b/0x2e0
> Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
> Dec  3 14:14:29 n22 =======================

Looks like your logger did not capture all the messages. Some important 
messages at the top were likely lost as a result. dmesg will have them, 
but you may have to increase the dmesg log buffer size in order to 
capture them all.

Did you press alt+sysrq+T or did all this come about as a result of the 
suspend?

Daniel
