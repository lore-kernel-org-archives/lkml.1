Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXJWSF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXJWSF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXJWSFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:05:49 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49656 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbXJWSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:05:48 -0400
Date: Tue, 23 Oct 2007 14:05:48 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Message-ID: <20071023180547.GL4003@csclub.uwaterloo.ca>
References: <471CDC5E.4010300@linux.intel.com> <20071022114001.40470c15.akpm@linux-foundation.org> <20071023150429.GK4003@csclub.uwaterloo.ca> <20071023092333.39982483@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023092333.39982483@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 09:23:33AM -0700, Arjan van de Ven wrote:
> gcc will tell you in the other direction just as well.
> 
> and people read from left to right (at least in english) so coding in
> that direction is generally preferred in the Linux kernel as well.

What does gcc have to say about if (foo = 0){ rather than if (foo == 0){

Both are legal C so it shouldn't say anything.  Of course the first is
usually a bug (or very bad style).

On the other hand if (0 = foo) will give an error.

It isn't about how you read in english, it is about not making mistakes.
And why can't you say if 0 is equal to the variable foo rather than if
the variable foo is equal to 0?  Both are valid english, so that is just
a crappy excuse for sticking with a bad idea.

--
Len Sorensen
