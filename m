Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYABUxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYABUxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbYABUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:53:08 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47257 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbYABUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:53:07 -0500
Date: Wed, 2 Jan 2008 13:53:06 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080102205306.GE11638@parisc-linux.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <alpine.LFD.1.00.0801021151420.32517@woody.linux-foundation.org> <20080102201734.GA13881@infradead.org> <alpine.LFD.1.00.0801021245460.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801021245460.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 12:49:32PM -0800, Linus Torvalds wrote:
> Maybe it's not that one suspicious test. Maybe it's somethign else. But 
> that commit was confirmed to break something, almost two months ago. You 
> guys seem to be in denial, and saying "it didn't change anything".
> 
> And no, waiting for more reporters when one reporter has already narrowed 
> it down to the exact (smallish) commit, is simply not good. Either you can 
> fix it by looking at the source, or it gets reverted.
> 
> I was hoping somebody in SCSI-land would actually look at the commit and 
> try to find out what's wrong, instead of all of you apparently trying to 
> say "nothing is wrong".

I've spent about a week of time looking at it over the last couple of
months.  I haven't been able to figure it out.  That's why I'm calling
for it to be reverted, not because I'm "in denial".

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
