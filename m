Return-Path: <linux-kernel-owner+w=401wt.eu-S933550AbXFRWu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbXFRWu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbXFRWuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:50:15 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:41773 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932546AbXFRWuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:50:13 -0400
Date: Tue, 19 Jun 2007 00:50:09 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070618225009.GE13538@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
	y-goto@jp.fujitsu.com
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:42:18PM -0700, Linus Torvalds wrote:
> You really do want to use git-1.5.x these days.
> 
> It does look like 1.4.4.4 may have a bug, although I'm really surprised: 
> we've certainly tweaked stuff in bisection, but I and others have used 
> "git bisect" since long before the git-1.4 days, and it has always worked 
> ok. So I wonder if it's something specific to that debian build.

Well, it does indeed.

Without changing ANYTHING to my linux-2.6 source tree - I just
installed git 1.5.2.1 and now it behaves the way you describe.

Conclusion: the weird behaviour that you think was wrong is
totally due to git 1.4.4.4.

I'll redo the bisect with this new git.

-- 
Carlo Wood <carlo@alinoe.com>
