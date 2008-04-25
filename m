Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbYDYVWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbYDYVWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbYDYVWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:22:36 -0400
Received: from homer.mvista.com ([63.81.120.158]:13022 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759204AbYDYVWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:22:35 -0400
Subject: Re: Announce: Semaphore-Removal tree
From: Daniel Walker <dwalker@mvista.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080425211250.GA13858@infradead.org>
References: <20080425170021.GH14990@parisc-linux.org>
	 <1209155917.12461.46.camel@localhost.localdomain>
	 <20080425211250.GA13858@infradead.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 14:22:31 -0700
Message-Id: <1209158552.12461.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-25 at 17:12 -0400, Christoph Hellwig wrote:
> On Fri, Apr 25, 2008 at 01:38:37PM -0700, Daniel Walker wrote:
> > I was reviewing your patches, and I don't like the semaphore to spinlock
> > changes.. There's no reason to start adding spinlocks, unless it's
> > really performance sensitive which none of those places are.. 
> 
> Yes, there is.  The spinlock is our most efficient locking primitive
> for the normal mostly un-contentded case.  Please get out of your
> realtime-ghetto.

If you can make a case for converting some semaphores to spinlocks be my
guest .. If you have good reasoning I wouldn't stand in the way.. (Real
time converts all the spinlocks to mutexes anyway ..)

Daniel

