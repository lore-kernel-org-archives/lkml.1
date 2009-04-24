Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZDXObl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZDXObl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZDXObb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:31:31 -0400
Received: from vena.lwn.net ([206.168.112.25]:44786 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbZDXOba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:31:30 -0400
Date: Fri, 24 Apr 2009 08:31:28 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       "=?ISO-8859-1?B?RnLpZOlyaWM=?= Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/5 -tip] umount_begin BKL pushdown
Message-ID: <20090424083128.0bf549df@bike.lwn.net>
In-Reply-To: <20090424115744.bd2d8444.sfr@canb.auug.org.au>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
	<20090423191817.GW8633@ZenIV.linux.org.uk>
	<20090423213249.GA4814@elte.hu>
	<20090424115744.bd2d8444.sfr@canb.auug.org.au>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 11:57:44 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > When that happens, could you please put it into a separate, 
> > append-only branch i could pull (after some initial test-time) into 
> > tip:kill-the-BKL?  
> 
> And just wondering how all this relates to Jonathan's (currently empty)
> bkl-removal tree (that is merged into linux-next)?

I set up my tree after a request from Linus; it was meant as a place
for near-term BKL-removal stuff to accumulate.  In the last couple of
cycles, it's only had a small trickle of stuff that I've been able to
do myself.  Ingo's tree is a rather grander vision, including a bunch
of debugging stuff and more.

The time for my tree may be nearing its end, but I'd just as soon keep
it around for a little longer.  I may yet find some time to do some
more work in this area.

jon
