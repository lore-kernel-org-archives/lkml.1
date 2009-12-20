Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZLTWN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZLTWN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 17:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZLTWNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 17:13:25 -0500
Received: from THUNK.ORG ([69.25.196.29]:33776 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbZLTWNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 17:13:24 -0500
Date: Sun, 20 Dec 2009 17:12:32 -0500
From: tytso@mit.edu
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       peterz@infradead.org, efault@gmx.de, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
Message-ID: <20091220221232.GC4887@thunk.org>
Mail-Followup-To: tytso@mit.edu, Ingo Molnar <mingo@elte.hu>,
	Joe Perches <joe@perches.com>, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	peterz@infradead.org, efault@gmx.de, akpm@linux-foundation.org,
	tglx@linutronix.de, linux-tip-commits@vger.kernel.org
References: <1261315437.4314.6.camel@laptop>
 <tip-3df0fc5b2e9d8092dcaeb5ae0b6753d85c851d66@git.kernel.org>
 <1261335300.30458.209.camel@Joe-Laptop.home>
 <20091220191531.GA17878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220191531.GA17878@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 08:15:31PM +0100, Ingo Molnar wrote:
> 
> It's also needlessly broken mid-string. Checkpatch should warn about printk 
> lines that end with a '"', those are almost always a sign of some ill-advised 
> break-the-string artifact.

Ironic, given that for a long time checkpatch strongly encouraged
people to do this with its "line too long" complaint.  Maybe all
printk's should be exempted from this, or at least if it's the format
string which is breaking whatever the magic boundary happens to be?

Even if we up the limit to 106, or 132, or whatever, I can imagine
situations where it will be *impossible* to shut up checkpatch.
Either it will bitch and moan about the line being too long, or it
will bitch and moan that a format string has been broken across
multiple lines.  :-(

					- Ted
