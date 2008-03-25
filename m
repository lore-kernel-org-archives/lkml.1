Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYCYAnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYCYAnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 20:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYCYAnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 20:43:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39622 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbYCYAnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 20:43:41 -0400
Date: Mon, 24 Mar 2008 17:42:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chr <chunkeey@web.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Greg KH <greg@kroah.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       stable@kernel.org
Subject: Re: inotify fixes in stable
Message-ID: <20080325004233.GN23462@sequoia.sous-sol.org>
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx> <20080310211346.GA6622@kroah.com> <200803111512.37605.nickpiggin@yahoo.com.au> <200803242333.30200.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803242333.30200.chunkeey@web.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chr (chunkeey@web.de) wrote:
> On Tuesday 11 March 2008 05:12:37 Nick Piggin wrote:
> >
> > The messages should actually be harmless. There is a race in the debug
> > code that can trigger them. But I wouldn't object to the patches going
> > to -stable...
> >
> let me guess... the patch didn't get into 2.6.24.4, right? because I still
> get these noisy "WARNING: at fs/inotify.c:172 set_dentry_child_flags()"
> and probably alot of other kde4 users too?!

a) doesn't appear to have been Cc'd to stable@kernel.org until now
(fell through one crack)
b) there was outstanding request from greg for clarification of the
issue for 2.6.24 (fell through another crack)

Please just explicitly send the fixes to stable@kernel.org and Cc Nick.

I'm actually disinclined to take 0d71bd5993b630a989d15adc2562a9ffe41cd26d
which seems to primarily just remove the WARN_ON(), although that is
assuming it is indeed no longer triggered with just the race fix,
d599e36a9ea85432587f4550acc113cd7549d12a.

thanks,
-chris
