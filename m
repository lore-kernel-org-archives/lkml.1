Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYCBWQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYCBWQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYCBWQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:16:35 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60190 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbYCBWQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:16:35 -0500
Date: Sun, 2 Mar 2008 23:16:23 +0100
From: Florian Westphal <fw-tipc@strlen.de>
To: tipc-discussion@lists.sourceforge.net
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>, per.liden@ericsson.com,
       jon.maloy@ericsson.com, allan.stephens@windriver.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [tipc-discussion] [PATCH] TIPC Protocol: Convert tsock->sem in
	a mutex
Message-ID: <20080302221623.GE14859@Chamillionaire.breakpoint.cc>
References: <20080302183637.GB2783@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302183637.GB2783@traven>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke <matthias@kaehlcke.net> wrote:
> TIPC Protocol: The semaphore tsock->sem is used as mutex, convert it
> to the mutex API

The locking mechanism was re-done in TIPC 1.7.X, and
AFAIK Allan Stephens is working on submitting
the current TIPC version for inclusion in 2.6.26.
So it probably doesn't make much sense to merge this patch
(even though it looks correct).

Sorry.
