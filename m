Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbYDYUiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbYDYUiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765397AbYDYUil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:38:41 -0400
Received: from homer.mvista.com ([63.81.120.158]:60954 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1765385AbYDYUik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:38:40 -0400
Subject: Re: Announce: Semaphore-Removal tree
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080425170021.GH14990@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 13:38:37 -0700
Message-Id: <1209155917.12461.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-25 at 11:00 -0600, Matthew Wilcox wrote:
> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore-removal
> 

I was reviewing your patches, and I don't like the semaphore to spinlock
changes.. There's no reason to start adding spinlocks, unless it's
really performance sensitive which none of those places are.. 

Also the ps3-gelic changes for instance is three locks in one patch. It
should be one lock per patch .. I have a broken out conversion for gelic
which I was going to submit in my next round ..

There's also a number of other people doing these , so you might want to
hold off on doing more unless you know they aren't already completed ..

Daniel

