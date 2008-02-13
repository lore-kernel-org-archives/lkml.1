Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbYBMRw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbYBMRw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbYBMRwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:52:20 -0500
Received: from mail.fieldses.org ([66.93.2.214]:44276 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090AbYBMRwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:52:18 -0500
Date: Wed, 13 Feb 2008 12:52:12 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213175212.GB13462@fieldses.org>
References: <47B1C9F4.30402@garzik.org> <20080212193754.GC18625@fieldses.org> <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org> <20080212.165014.01238510.davem@davemloft.net> <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org> <20080213042512.GB9766@fieldses.org> <alpine.LFD.1.00.0802122127110.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802122127110.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:43:10PM -0800, Linus Torvalds wrote:
> So just the fact that the right commit gets blamed when somebody does a 
> "git bisect" is I think a big issue. It's just fundamentally more fair to 
> everybody. And it means that the people who push their work to me can 
> really choose to stand behind it, knowing that whatever happens, their 
> work won't get diluted by bad luck or others' incompetence.
> 
> And no, maybe most people don't feel things like that matters. But I do 
> think it's important.

The obvious advantage to rebasing in this case is that the blame
(misplaced though it may be), at least lands on a commit that made a
single small change, likely making the problem easier to diagnose.

(As opposed to the case of a large merge, where all you may know is that
somewhere in the hundreds of commits done on one side of the merge there
was a conflict with the hundreds of commits on the other side.)

I think a lot of people would see rebasing as an acceptable tradeof that
gives up a small amount of accuracy in assigning blame to individuals in
return for a large increase in ability to debug problems.

I suppose one response to that would be that it's important that people
learn how to work in parallel, that failures to do so are particularly
important failures in the process, and that it's therefore worth it to
make sure that such failures are always identified specifically as merge
failures.

It would be nice if merges, like patches, were broken up into somewhat
smaller units.  There's an understandable desire to wait to the last
minute to actually commit to one's commits, but a willingness to do so a
little earlier might avoid some of the problems that seem to come from
having a lot of large merges happen all at once.

--b.
