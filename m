Return-Path: <linux-kernel-owner+w=401wt.eu-S1422973AbXCOWUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422973AbXCOWUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422987AbXCOWUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:20:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:47758 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933932AbXCOWUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:20:04 -0400
Date: Thu, 15 Mar 2007 23:19:02 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
In-Reply-To: <20070315142955.7cbe62c1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703152317260.12394@twin.jikos.cz>
References: <200703122214.02657.rjw@sisk.pl> <200703122219.21171.rjw@sisk.pl>
 <20070315110816.8b4102b3.akpm@linux-foundation.org> <200703152205.54639.rjw@sisk.pl>
 <20070315142955.7cbe62c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Andrew Morton wrote:

> > > And why _does_ suspend use GFP_ATOMIC all over the place?
> > Generally, because it cannot sleep.
> Why not?

I guess it's simply beucase of kswapd being already frozen, so there is no 
chance that once GFP_KERNEL allocation goes to sleep, it is going to get 
any free pages eventually ... ?

-- 
Jiri Kosina
