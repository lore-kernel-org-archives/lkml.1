Return-Path: <linux-kernel-owner+w=401wt.eu-S935208AbXKPWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935208AbXKPWAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbXKPWA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:00:28 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57725
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbXKPWA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:00:28 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken in 2.6.23.1)
Date: Fri, 16 Nov 2007 16:00:22 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Greg KH <greg@kroah.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
References: <200711032351.52977.rob@landley.net> <20071116071527.GE31582@kroah.com> <20071116155108.GA5453@c2.user-mode-linux.org>
In-Reply-To: <20071116155108.GA5453@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161600.23745.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007 09:51:08 Jeff Dike wrote:
> On Thu, Nov 15, 2007 at 11:15:27PM -0800, Greg KH wrote:
> > Rob, I'll queue this up for the next cycle, now that you've verified
> > that it was not fixed already, thanks for testing.
>
> I wouldn't.
>
> sparc includes swap.h in its pgtable.h.  Adding pagemap.h to swap.h
> completes an include loop on sparc which blows up its build.
>
> I have a set of patches to fix this in a different way, which I sent
> out for comments a few weeks ago.

I wasn't cc'd, and missed it.  I'd like to test this, do you have a link?  (Or 
a bit more specificity than "a few weeks ago"?)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
