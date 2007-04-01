Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbXDATDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbXDATDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933917AbXDATDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:03:42 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58211 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933908AbXDATDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:03:39 -0400
Date: Sun, 1 Apr 2007 21:01:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 07/16] kconfig-dynamic-frequency.diff
In-Reply-To: <2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com>
Message-ID: <Pine.LNX.4.61.0704012058060.16977@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr>
 <B118D361-9F40-456F-96B7-E61B16B98432@mac.com> <Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr>
 <2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 14:52, Kyle Moffett wrote:
>
> On Apr 01, 2007, at 14:42:59, Jan Engelhardt wrote:
>> But I would have to ask: Why do we need 100/250/300/1000 if there
>> is anyway an input field for the user to enter - s/he should read
>> the help text for Known Good values, should not s/he?
>
> Actually, probably what should be done is make the "HZ_CUSTOM"
> option depend on EXPERIMENTAL / EMBEDDED / "EXPERT" /
> "I_KNOW_WHAT_THE_HELL_IM_DOING" or some other equivalent option,

EXPERIMENTAL is most often enabled by distributors.
And we are still missing our much-needed CONFIG_EXPERT :-(

> because a wrong choice for HZ has the potential to really screw up
> a system.  For example, 10000+ would make most systems spend a
> significant portion of their time processing timer interrupts and

Point taken. Ehm, I already once tried making a 10000-Hz kernel
around 2.6.13-15 or so. It did not compile because some header files had
#error directives for HZ >= 1536. (jiffies.h:33 if you want
to know.) IIRC there also was another place somewhere in networking
code that #errors out at >8192.


Jan
-- 
