Return-Path: <linux-kernel-owner+w=401wt.eu-S933423AbXHAPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbXHAPMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932713AbXHAPMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:12:01 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15407 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbXHAPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:12:00 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1185969554.9513.106.camel@ghaskins-t60p.haskins.net>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185969554.9513.106.camel@ghaskins-t60p.haskins.net>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 08:10:25 -0700
Message-Id: <1185981025.2636.102.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 07:59 -0400, Gregory Haskins wrote:
> On Tue, 2007-07-31 at 20:52 -0700, Daniel Walker wrote:
> 
> > 
> > Here's a simpler version .. uses the plist data structure instead of the
> > 100 queues, which makes for a cleaner patch ..
> 
> Hi Daniel,
> 
> I like your idea on the plist simplification a lot.  I will definitely
> roll that into my series.
> 
> I am not too psyched about using the rt_mutex_setprio() API directly,
> however.  It seems broken to be calling that directly from non rt_mutex
> code, IMHO.  Perhaps the PI subsystem should be broken out from the
> rt_mutex code so it can be used generally?  There are other areas where
> PI could potentially be used besides rt_mutex (this patch as a prime
> example), so this might make sense.

rt_mutex_setprio() is just a function. It was also designed specifically
for PI , so it seems fairly sane to use it in other PI type
situations ..

Daniel

