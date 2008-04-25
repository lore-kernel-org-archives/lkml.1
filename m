Return-Path: <linux-kernel-owner+w=401wt.eu-S1765606AbYDYUYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765606AbYDYUYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbYDYUYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:24:14 -0400
Received: from homer.mvista.com ([63.81.120.158]:55054 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764440AbYDYUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:24:14 -0400
Subject: Re: Announce: Semaphore-Removal tree
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080425170021.GH14990@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 13:24:09 -0700
Message-Id: <1209155049.12461.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-25 at 11:00 -0600, Matthew Wilcox wrote:
> It's been a Good Idea for a while to use mutexes instead of
> semaphores where possible.  Additional debuggability, better optimised,
> better-enforced semantics, etc.
> 
> Obviously, there are some places that can't be converted to mutexes.
> I'm not proposing blind changes.  I've been through a dozen places
> and found some that can be converted to spinlocks, others to
> completions, but mostly to mutexes.  So as not to lose these patches,
> I've made them available as a git tree.  I think the right way to get
> these patches in will be to go through the maintainers of each file.
> 
> I'll post a list of the places using semaphores later.  My current list
> is a bit out of date and contains insulting comments that I would like
> to rephrase before the authors of the code in question see them ;-)

I've got a bunch of these if you want to incorporate them.. I've been
slowly trickling them up stream ..

Daniel

