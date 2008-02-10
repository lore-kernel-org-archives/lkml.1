Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYBJHe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYBJHe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYBJHeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:34:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYBJHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:34:19 -0500
Date: Sun, 10 Feb 2008 02:34:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [1/6] pids: add pid_max prototype
Message-ID: <20080210073414.GA26666@infradead.org>
References: <20080210071321.GA3851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210071321.GA3851@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 08:13:21AM +0100, Ingo Molnar wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> add pid_max prototype - used by sysctl and will be used by kgdb as well.

Looks good, and this should go in ASAP independent of kgdb.

And while you're at it, I think all of the below want to find a suitable
place in a header somewhere:

> @@ -71,7 +72,6 @@ extern int max_threads;
>  extern int core_uses_pid;
>  extern int suid_dumpable;
>  extern char core_pattern[];
> -extern int pid_max;
>  extern int min_free_kbytes;
>  extern int pid_max_min, pid_max_max;
>  extern int sysctl_drop_caches;
