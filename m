Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYAEQir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYAEQir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbYAEQih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:38:37 -0500
Received: from mx1.suse.de ([195.135.220.2]:51574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbYAEQig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:38:36 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>,
       " Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
References: <477F6B23.3050108@gmail.com>
	<1199543075452@dmwebmail.japan.chezphil.org>
X-Yow: Spreading peanut butter reminds me of opera!!  I wonder why?
Date: Sat, 05 Jan 2008 17:38:34 +0100
In-Reply-To: <1199543075452@dmwebmail.japan.chezphil.org> (Phil Endecott's
	message of "Sat\, 05 Jan 2008 14\:24\:35 +0000")
Message-ID: <jed4sgjkhh.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:

> However, there's a lot of code and I know that there are bugs in it.  I
> just want to focus on the kernel-related issue that the strace fragment
> that I posted brings up:  even if my user code gets completely screwed up
> (corrupts its stack, runs out of FDs/VM/threads etc), I don't think that I
> should see in the strace output that accept() has returned
> ERESTARTSYS.

strace always sees the raw return value, before the signal handler is
executed and before the check for syscall restart is done.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
