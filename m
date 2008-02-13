Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbYBMEZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbYBMEZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYBMEZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:25:20 -0500
Received: from mail.fieldses.org ([66.93.2.214]:38085 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbYBMEZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:25:18 -0500
Date: Tue, 12 Feb 2008 23:25:12 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213042512.GB9766@fieldses.org>
References: <47B1C9F4.30402@garzik.org> <20080212193754.GC18625@fieldses.org> <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org> <20080212.165014.01238510.davem@davemloft.net> <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 05:31:10PM -0800, Linus Torvalds wrote:
> The importance of merging (rather, not screwing up history in general) 
> becomes really obvious when things go tits-up. Then they go tits-up 
> *without* screwing up the history of the trees that were hopefully tested 
> individually.
> 
> If you re-base things that others developed, you lose that. Imagine if I 
> merged first Greg's tree (by rebasing), and then there was some 
> fundamental thing that didn't cause a conflict, but just made something 
> not work, when I rebased yours on top. Think about what happens.
> 
> Now I've merged (say) 1500 networking-related commits by rebasing, but 
> because I rebased on top of Greg's tree that I had also rebased, 
> absolutely *none* of that has been tested in any shape of form. I'd not 
> use most of the things I pulled, so I'd never see it, I'd just push out 
> something that was very different from *both* trees I pulled, with no way 
> to really blame the merge - because it doesn't even exist.
> 
> So as a result, some *random* commit that was actually fine on its own has 
> now become a bug, just because it was re-written. 

If there was a "fundamental thing that didn't cause a conflict", then
the two trees in question probably didn't touch the same code, so would
probably merge cleanly, for the same reason that one rebased onto the
other cleanly.  But depending on what the "fundamental thing" was, the
merge might still introduce the same bug, right?

--b.
