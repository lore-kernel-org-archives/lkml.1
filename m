Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYHYJ0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYHYJ0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYHYJZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:25:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbYHYJZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:25:55 -0400
Date: Mon, 25 Aug 2008 11:25:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alex Nixon <alex.nixon@citrix.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 5/5] Xen:  Implement CPU hotplugging
Message-ID: <20080825092541.GA26287@elte.hu>
References: <1219402335-29773-1-git-send-email-alex.nixon@citrix.com> <1219402335-29773-2-git-send-email-alex.nixon@citrix.com> <1219402335-29773-3-git-send-email-alex.nixon@citrix.com> <1219402335-29773-4-git-send-email-alex.nixon@citrix.com> <1219402335-29773-5-git-send-email-alex.nixon@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219402335-29773-5-git-send-email-alex.nixon@citrix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0894]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Nixon <alex.nixon@citrix.com> wrote:

>  arch/x86/xen/smp.c      |   60 +++++++++++++++++++++++++++++++++++++---------
>  arch/x86/xen/spinlock.c |    5 ++++
>  arch/x86/xen/time.c     |    8 ++++++
>  arch/x86/xen/xen-ops.h  |    6 ++++
>  drivers/xen/Makefile    |    2 +-
>  drivers/xen/events.c    |    4 +++
>  6 files changed, 72 insertions(+), 13 deletions(-)

this was causing:

 make[2]: *** No rule to make target `drivers/xen/cpu_hotplug.o', needed by `drivers/xen/built-in.o'.  Stop.
 make[1]: *** [drivers/xen] Error 2
 make[1]: *** Waiting for unfinished jobs....

then i discovered the missing file in a patch you re-sent and which 
wasnt in the original series. Please point out the reason for resends.

	Ingo
