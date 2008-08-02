Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYHBBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYHBBBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYHBBBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 21:01:07 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52839 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYHBBBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 21:01:06 -0400
Date: Fri, 1 Aug 2008 21:00:44 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [stable] [PATCH 1/14] uml: fix build when SLOB is enabled
Message-ID: <20080802010044.GA16405@c2.user-mode-linux.org>
References: <20080801224125.GA13727@c2.user-mode-linux.org> <20080801230624.GA22233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801230624.GA22233@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 04:06:24PM -0700, Greg KH wrote:
> On Fri, Aug 01, 2008 at 06:41:25PM -0400, Jeff Dike wrote:
> > >From 94409ded7768e15b0d0a5a172d611073c72308de Mon Sep 17 00:00:00 2001
> 
> These git commit ids don't match up to anything in Linus's tree at all
> :(

Hmmm, OK I'll figure out where the commit ids came from.  I
cherry-picked them from 2.6.26 into 2.6.25.13, so I guess they got new
ids when I did that.

I'll resend with the original ids...

> Oh, in the future it is simple to get patches into the -stable tree
> automatically, just add:
> 	Cc: Stable <stable@kernel.org>
> to the signed-off-by: area of the patch.  When it goes into Linus's
> tree, it will be automatically sent to us for inclusion in the next
> -stable release.

Yeah, I'll do that in future, but it was a little late for these
patches.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
