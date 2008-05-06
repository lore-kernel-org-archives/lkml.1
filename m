Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbYEFQpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbYEFQpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760781AbYEFQpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:45:22 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56304 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477AbYEFQpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:45:21 -0400
Date: Tue, 6 May 2008 12:44:59 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, richterd@citi.umich.edu
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506164459.GG592@fieldses.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 09:36:06AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 6 May 2008, Matthew Wilcox wrote:
> > 
> > I've wanted to fix file locks for a while.  Here's a first attempt.
> > It was done quickly, so I concede that it may well have bugs in it.
> > I found (and fixed) one with LTP.
> 
> Hmm. Wouldn't it be nicer to make the lock be a per-inode thing? Or is 
> there some user that doesn't have the inode info, or does anything that 
> might cross inode boundaries?

The deadlock detection crosses inode boundaries.

--b.
