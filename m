Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbYDQKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbYDQKAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934390AbYDQJed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:34:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933417AbYDQJeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:34:31 -0400
Date: Thu, 17 Apr 2008 02:33:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417023331.3350e217.akpm@linux-foundation.org>
In-Reply-To: <20080417.021935.170766914.davem@davemloft.net>
References: <20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417.014534.258800340.davem@davemloft.net>
	<20080417015425.312d34c0.akpm@linux-foundation.org>
	<20080417.021935.170766914.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 02:19:35 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 17 Apr 2008 01:54:25 -0700
> 
> > linux-next ramped up across the 2.6.25-rc window and I wanted to give it
> > some time to see how it would pan out.
> ...
> > I don't know what you mena by this.  But linux-next integrates only the
> > other subsystem trees and they have rarely caused me integration problems
> > against git-net.  

There are maybe as many as 100 "subsystem trees" hosted in -mm.  Stuff like
md, ipmi, tty, elf, keys, procfs, char drivers, nbd, fbdev, aoe, fuse, edac
and the list goes on.

Once I get -mm based on linux-next, the next step is to somehow feed those
trees (well, the "stable" parts thereof) back into linux-next while not
losing track of all the patches.  I haven't a clue how I'll do this ;)

But I haven't thought about it much yet.
