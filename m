Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYL1WBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYL1WBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYL1WBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:01:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbYL1WBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:01:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Scott James Remnant <scott@canonical.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Notify init when processes are reparented to it
In-Reply-To: Oleg Nesterov's message of  Sunday, 28 December 2008 10:20:24 +0100 <20081228092024.GA21673@redhat.com>
References: <1230378128.7026.50.camel@quest>
	<20081227114452.GA2919@zelda.netsplit.com>
	<20081228092024.GA21673@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20081228220122.62940FC278@magilla.sf.frob.com>
Date: Sun, 28 Dec 2008 14:01:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm highly skeptical that this is a desireable feature at all, and
certainly I find the abuse of siginfo_t.si_status here extremely
questionable.  I think we need a clear explanation of what problems
the feature is intended to address.


Thanks,
Roland
