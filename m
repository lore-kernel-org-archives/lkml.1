Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYANJs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYANJs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYANJsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:48:18 -0500
Received: from main.gmane.org ([80.91.229.2]:53503 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbYANJsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:48:17 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Mon, 14 Jan 2008 09:48:00 +0000 (UTC)
Message-ID: <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
References: <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi> <1200303743.24517.6.camel@tara.firmix.at>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-14, Bernd Petrovitsch <bernd@firmix.at> wrote:
> Yes, that is a usual bug/problem in common distributions[0] as there is
> no real guarantee that your clock is not far off.

It isn't, right after boot. But while the system is on, it sometimes
starts advancing very fast, 15min a day or so. To my knowledge, the
time the CMOS clock is not used then, but rather the kernel tracks the
time based on scheduler interrupts, with ntpd occasionally correcting.
However, ntpd refuses to correct when the time has drifted too much, 
causing even further drift.


> That the reason to activate `ntpdate` unconditionally: It sets the
> current time to an (somewhat) accurate value and `ntpd` handles the
> rest.

Nope, as explained above. ntpdate at boot wouldn't help much, because
the time is (approximately) correct after boot. It only drifts after it.

-- 
Tuomo

