Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbZKQUeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbZKQUeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZKQUeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:34:09 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:35789 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZKQUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:34:08 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Uwe =?utf-8?Q?Kleine-?= =?utf-8?Q?K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
	<200911171916.41727.mb@bu3sch.de>
X-Yow: I wonder if I should put myself in ESCROW!!
Date: Tue, 17 Nov 2009 21:34:11 +0100
In-Reply-To: <200911171916.41727.mb@bu3sch.de> (Michael Buesch's message of
	"Tue, 17 Nov 2009 19:16:40 +0100")
Message-ID: <m2pr7g3n7g.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch <mb@bu3sch.de> writes:

> Well, that doesn't actually return the difference at all. Is that allowed?

The only requirement is that the compare functions return <0,0,>0
depending on the order.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
