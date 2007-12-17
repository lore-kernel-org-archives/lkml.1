Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXLQNcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXLQNcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbXLQNcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:32:11 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:61544 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbXLQNcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:32:09 -0500
To: indan@nul.nu
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <476512F1.5010701@davidnewall.com>
	<200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
	<46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
	<200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
	<54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
In-Reply-To: <54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
Message-Id: <200712172232.CFI17125.tFHOFFQLSOOVJM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 17 Dec 2007 22:32:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( This is a reply to http://lkml.org/lkml/2007/12/17/27 .)

Hello.

David Wagner wrote:
> But the point is that it's not enough just to prevent attackers
> from mounting other filesystems over this filesystem.  I can think
> of all sorts of ways that an admin-level attacker might be able to
> prevent other administrators from logging in.  If your defense strategy
> involves trying to enumerate all of those possible ways and then shut
> them down one by one, you're relying upon a defense strategy known as
> "blacklisting".  Blacklisting has a terrible track record in the
> security field, because it's too easy to overlook one pathway.
Of course, I assume whitelisting.
SELinux and TOMOYO Linux and many other MAC implementations uses
whitelisting approach, and this filesystem is whiltelisting approach.

This filesystem handles what MAC implementations don't handle.
In other words, it is a remaining hole.

I'm proposing:

 Don't you think it is dangerous to assume files in /dev directory
 have appropriate filename and attributes binding?
 MAC can restrict processes who can create files in /dev directory,
 but MAC doesn't enforce filename and attributes binding.
 So, how about enforcing filename and attributes binding in filesystem layer?

Regards.

To David Wagner:
  Could you please Cc: me so that I can reply to your message?
  I can't reply to your message since I'm reading this ml in daily digest mode.
