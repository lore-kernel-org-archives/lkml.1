Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYLJXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYLJXnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYLJXnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:43:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40465 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYLJXnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:43:10 -0500
Date: Wed, 10 Dec 2008 23:43:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] make INIT_FS use the __RW_LOCK_UNLOCKED initialization
Message-ID: <20081210234307.GI28946@ZenIV.linux.org.uk>
References: <alpine.DEB.1.10.0812101832200.21545@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812101832200.21545@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 06:37:28PM -0500, Steven Rostedt wrote:
> 
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: cleanups

Would be better to take init_fs to something in fs/ or kernel/ and kill
the duplicates, along with INIT_FS macro itself...
