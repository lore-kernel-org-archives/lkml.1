Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXJHUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXJHUjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXJHUjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:39:05 -0400
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:20860 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752274AbXJHUjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:39:03 -0400
X-YMail-OSG: VhE80hwVM1n3TZsMUieLKJIuLxNAcmAwxVKKsu1rqC9_mIQBLJP_KNNTLMRSzKefaSeoF8gfYg--
X-RocketYMMF: rancidfat
Date: Mon, 8 Oct 2007 13:39:01 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m1hcl11j31.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <384716.99898.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Eric W. Biederman" <ebiederm@xmission.com> wrote:


> My very practical question:  How do I run selinux in one container,
> and SMACK in another?

How would you run PREEMPT_RT in one container, and PREEMPT_DESKTOP
in another? How would you run SMP in one and UP in the other?
One aspect that SELinux and Smack share is that they only really
provide security if all processes involved are under their control,
just like the preemption behavior.

This is not necessarily true of all possible LSMs. In that case it may
be practicle to have different behavior for different containers.


Casey Schaufler
casey@schaufler-ca.com
