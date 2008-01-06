Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYAFRMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYAFRMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYAFRMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:12:00 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48944 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbYAFRMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:12:00 -0500
Date: Sun, 6 Jan 2008 10:11:58 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106171158.GM20473@parisc-linux.org>
References: <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199632845.5205.31.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 09:20:45AM -0600, James Bottomley wrote:
> This bug was actually hidden in bugzilla for ages, where Matthew Wilcox
> was trying to deal with it on his own.  The first I heard of it (apart
> from a linux-scsi question on 13 November, when regrettably, I was busy
> with other things) was on 18 Dec when Natalie added me to the bugzilla
> cc list.  The first thing I did on that date was finger pktcdvd and add
> Jens to the cc list ... however, since there was no mailing list thread
> to follow he ended up asking for context which no-one provided.

Not true.  I sent my response to the bug to linux-scsi and cc'd bugzilla.
Unfortunately, the bug reporter sent the information requested to bugzilla
instead of linux-scsi.  So it got lost and overlooked.

If there's willingness to change, I'm willing to put some effort into
moving us to a bug tracking system that fits our workflow better than
bugzilla.  But if that effort will be disregarded, then let me know now
so I don't waste my time.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
