Return-Path: <linux-kernel-owner+w=401wt.eu-S1764745AbXKNUk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764745AbXKNUk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbXKNUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:40:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760533AbXKNUkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:40:15 -0500
Date: Wed, 14 Nov 2007 12:40:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071114124008.095f307d.akpm@linux-foundation.org>
In-Reply-To: <20071114202959.GA21049@linux.intel.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<473A678C.2020507@googlemail.com>
	<473A76FA.4050701@googlemail.com>
	<20071114202959.GA21049@linux.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 12:29:59 -0800 mark gross <mgross@linux.intel.com> wrote:

> > > [  102.366932]  =======================
> > > [  108.552031] printk: 31 messages suppressed.
> > 
> > 
> > All this BUG / WARNINGS are caused by *-qos* patches. Reverting this 3 patches makes the BUGs go away :
> > 
> > latencyc-use-qos-infrastructure.patch
> > pm-qos-infrastructure-and-interface.patch
> > pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
> > 
> > 
> > Gabriel
> > 
> > 
> This looks like the same issue Rafael saw.
> 
> Try the patch in the following post:
> 
> http://marc.info/?l=linux-kernel&m=119265627228498&w=2
> 

Well that's not very good.  _I_ can go fishing in my lkml archives for random
patches but not everyone is set up to do that.  And the diff to which you
refer gets 100% rejects against rc2-mm1 anyway.

Please prepare a tested, changelogged patch against rc2-mm1 asap.  
