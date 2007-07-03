Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbXGCMEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbXGCMEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbXGCMD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:03:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:57138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbXGCMD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:03:56 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
To: Miklos Szeredi <miklos@szeredi.hu>, oliver@neukum.org,
       linux-pm@lists.linux-foundation.org, benh@kernel.crashing.org,
       nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 03 Jul 2007 14:03:07 +0200
References: <8CIbE-3y1-1@gated-at.bofh.it> <8CJKt-62G-35@gated-at.bofh.it> <8CKZS-7Ur-3@gated-at.bofh.it> <8CLjc-8iq-29@gated-at.bofh.it> <8CO7m-4k4-11@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I5h64-0000fs-34@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX196v3v9NC/Gq92+okKb+gYz3cYY8JxdCIKQvfO
 HOzxcVgyyL2SCLWoowj+W/T9xxDbeA0ZA4JFfz+5dDjzNbRCai
 RuZvKbvwgdL0LyVfrZSnw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

>> > So to summarize, the plan that makes things work with fuse is:
>> > 
>> > - For STR, don't do the freezer thing.
>> > 
>> > - For STD, don't sys_sync() after you froze
>> > 
>> > There might be -other- issues, but that should get you through some of
>> 
>> At the risk of repeating myself. Character device drivers are written
>> with the assumption that normal io and suspend/resume do not race
>> with each other due to the freezer.
>> What do you intend to do about that?
> 
> Oliver, can you please explain your worries in a bit more detail?

Try suspending while printing.
-- 
What's worse than a Male Chauvinist Pig?
A woman that won't do what she's told.

Friﬂ, Spammer: tgyvaxz@.qcLz7l.7eggert.dyndns.org
