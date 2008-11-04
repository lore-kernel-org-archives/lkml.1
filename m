Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYKDR76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYKDR76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYKDR7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:59:46 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:65320 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbYKDR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:59:45 -0500
Message-ID: <49108D92.9070306@lwfinger.net>
Date: Tue, 04 Nov 2008 09:59:46 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Alan <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: System hang from holding left shift key
References: <490EAB65.1000908@lwfinger.net> <20081104105600.GA4514@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081104105600.GA4514@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> While absentmindedly holding down the left shift key as I was thinking about my
>> next input, I froze the keyboard. After 3 seconds, the system sounded a high
>> beep, and then a low beep after another 3 seconds. At that point, no key entry
>> had any effect. From the beeps, one might conclude that the input buffer is
>> full, but a CTRL/U did not clear it. Fortunately, a short press on the power
>> button shut down the machine cleanly.
>>
>> I don't know if this is a regression. I found it in v2.6.28-rc2, but the oldest
>> kernel that I could test (v2.6.24) already has the problem.
>>
>> When the beeps occur, a stack dump is as follows:
> 
> What kind of machine is that...? I can't reproduce it here, do I need
> some accessibility options enabled?

It is an HP dv2815nr notebook with an Turion X2 CPU running the x86_64 version
of openSUSE 11.0.

I'm not running any special options that I know about. The only strange thing is
that the shift keys autorepeat.

Larry

