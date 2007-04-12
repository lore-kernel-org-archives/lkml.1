Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXDLRCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXDLRCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030489AbXDLRCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:02:25 -0400
Received: from smtp-out03.alice.it ([85.37.17.99]:4538 "EHLO
	smtp-out03.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030506AbXDLRCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:02:23 -0400
Date: Thu, 12 Apr 2007 19:02:20 +0200
From: Mattia Dongili <malattia@linux.it>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070412170220.GA2997@inferi.kami.home>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070412151402.GA3216@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412151402.GA3216@inferi.kami.home>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc6-mm1-2 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 12 Apr 2007 17:02:21.0576 (UTC) FILETIME=[55D67080:01C77D24]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 05:14:02PM +0200, Mattia Dongili wrote:
> On Thu, Apr 05, 2007 at 07:50:11PM -0700, Linus Torvalds wrote:
> ...
> > Maxim Levitsky (1):
> >       Add suspend/resume for HPET
> 
> This one breaks resume for me (from STR) on a vaio SZ. Reverting this
> commit allows resuming again but leaves me with some periodic and unpleasant:
> 
> [  155.232000] BUG: soft lockup detected on CPU#1!

A couple more info (probably useless but...):
- I noticed the resume problem in -rc6-mm1 but reverting the same patch
  there doesn't make the laptop resume again
- last known succesful resuming kernel: 2.6.21-rc5-mm3 (and without
  hitting the BUG() above after resume)

-- 
mattia
:wq!
