Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbYDQL63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbYDQL63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYDQL6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:58:17 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:65457 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYDQL6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:58:16 -0400
To: pavel@ucw.cz
Cc: casey@schaufler-ca.com, sds@tycho.nsa.gov, crispin@crispincowan.com,
       serue@us.ibm.com, matthew@wil.cx, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1208182620.18883.92.camel@moss-spartans.epoch.ncsc.mil>
	<484889.77284.qm@web36604.mail.mud.yahoo.com>
	<200804152014.IAB35427.tFLHSMOQOFOFJV@I-love.SAKURA.ne.jp>
	<20080416191315.GB3923@ucw.cz>
In-Reply-To: <20080416191315.GB3923@ucw.cz>
Message-Id: <200804172058.BHI60408.OtFFMOJHOLQVSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 17 Apr 2008 20:58:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pavel Machek wrote:
> > It is true that namespace may differ between processes,
> > but I think that that is the matter of how to restrict namespace manipulation operations.
> > As I said, a system can't survive if namespace is madly manipulated.
> > To keep the system workable, /bin/ must be the directory for binary programs,
> > /etc/ must be the directory for configuration files, and so on in all namespaces.
> 
> Ehm? Where did you get those ideas?
> 
> I'm free to name my directories any way I want, and keep config files
> in /pavlix_config, thank you... There is even distro that does
> something like that, IIRC...
> 
We can make processes have different namespace by using clone() with CLONE_NEWNS.
But even if some process got a different namespace, it need to follow conventional rules.
Optional files (e.g. /pavlix_config) need not to follow conventional rules.
What I'm talking about is essetial files (e.g. /bin/sh and /etc/passwd).
Can your system continue running even if essetial files are not in place
(like /bin/sh moved to /etc/sh and /etc/passwd moved to /bin/passwd) ?
I don't think so...

Thanks.
