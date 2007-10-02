Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXJBAOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXJBAOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 20:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXJBAN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 20:13:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43207 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752072AbXJBANz (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 20:13:55 -0400
Message-ID: <47018D3C.9070409@sgi.com>
Date: Tue, 02 Oct 2007 10:13:48 +1000
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com> <alpine.LFD.0.999.0710010753500.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710010753500.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 1 Oct 2007, Tim Shimmin wrote:
>> Lachlan's description:
>>     This fix is for a problem that has been in XFS since day one.
>>     [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.
> 	...
> 
> Why wasn't this in the commit logs? Now it just says it was reverted, with 
> no actual reasoning *why*. And it apparently wasn't so obvious that no 
> such reasoning is needed.
> 
> Gah. I ended up amending the commit and updating it with the comment.
> 
> 		Linus

Yeah, sorry about that.
It occurred to me later on.
I initially converted the sgi-mod (undo mod) to a git commit and
then discovered git-revert and thought, hey I'll use that
instead but then forgot to add all the text into it.
D'oh. Thanks for the fixup.

--Tim
