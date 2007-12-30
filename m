Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXL3FaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXL3FaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 00:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXL3F3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 00:29:55 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63827 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbXL3F3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 00:29:54 -0500
To: Valdis.Kletnieks@vt.edu
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071226164230.GA14210@sergelap.austin.ibm.com>
	<200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp>
	<20071227145431.GB5161@sergelap.austin.ibm.com>
	<200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp>
	<27904.1198862631@turing-police.cc.vt.edu>
In-Reply-To: <27904.1198862631@turing-police.cc.vt.edu>
Message-Id: <200712301429.FEF05784.FtFOVJHOOLMSQF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 30 Dec 2007 14:29:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Valdis.Kletnieks@vt.edu wrote:
> Please make a *big* notation someplace that "learning mode" is quite likely to
> *not* produce a totally correct policy.  In particular, it won't build rules for
> infrequently used code paths (such as error handling) unless you find a way to
> exercise those paths while in learning mode.
Use of "learning mode" is independent from "correct policy".
The "learning mode" merely takes your duty of appending permissions to policy.
We can develop and share procedures for how to exercise infrequently used code
paths, like how to confirm that your SMTP service won't relay spams.
This problem is nothing but "developing and sharing procedures for how to
exercise infrequently used code paths" has not started yet.

By the way, what is the definition of "correct policy"?
The definition of "correct policy" depends on the user.

Some users may think that

  "A ready-made policy is better than a manually-made policy
   even if the ready-made policy contains unused/unneeded permissions.
   Being unable to handle infrequently used code paths is worse than
   leaving a room for not knowing/understanding what can happen."

but other users may think that

  "A manually-made policy is better than a ready-made policy
   even if the manually-made policy lacks permissions for infrequently
   used code paths.
   Leaving a room for not knowing/understanding what can happen is worse than
   being unable to handle infrequently used code paths."

You can use "permissive mode" to adjust and confirm your policy
before you use "enforcing mode".
You can also use "delayed enforcing mode" that allows an administrator
handle infrequently used code paths without once rejecting those code paths.
If the policy is not correct, it is the person's fault who enforced that policy
without confirming that that policy is suitable for his/her system.

Since the definition of "correct policy" is not a globally agreed word,
I think we can't say that "learning mode unlikely produces correct policy".

Thanks.
