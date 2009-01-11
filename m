Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZAKKMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZAKKMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 05:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZAKKMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 05:12:33 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48384 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZAKKMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 05:12:31 -0500
Date: Sun, 11 Jan 2009 18:11:35 +0800
From: Andreas Dilger <adilger@sun.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
	measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
In-reply-to: <20090110211531.GD31579@mit.edu>
To: Theodore Tso <tytso@mit.edu>, Mike Snitzer <snitzer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
       Dave Anderson <anderson@redhat.com>
Message-id: <20090111101135.GA3306@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
 <20090110153446.GA13976@elte.hu>
 <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
 <20090110211531.GD31579@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2009  16:15 -0500, Theodore Ts'o wrote:
> In my experience, there are very few kernel versions and hardware for
> which kdump works.  I've talked to the people who have to make kdump
> work, and every 12-18 months, with a new set of enterprise kernels
> comes out, they have to go and fix kdump so it works again for the set
> of hardware that they care about, and for the kernel version involved.

I'm sad that netconsole/netdump never made it big.  It was fairly useful,
and extending the eth drivers to add the polling mode was trivial to do.
We were using that for a few years, but it got replaced by kdump and it
appears to be less usable IMHO.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

