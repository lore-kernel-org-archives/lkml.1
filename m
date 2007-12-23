Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXLWLhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXLWLhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 06:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXLWLhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 06:37:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXLWLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 06:37:12 -0500
Date: Sun, 23 Dec 2007 03:34:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: 2.6.24-rc6-mm1
Message-Id: <20071223033424.01dab700.akpm@linux-foundation.org>
In-Reply-To: <20071223111004.GA2259@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<20071223110456.GB10818@elte.hu>
	<20071223111004.GA2259@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007 12:10:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> > > 
> > > - This kernel doesn't work on i386!
> > > 
> > >   It oopses late in boot due to an unrevertable change (e3c1b141) in 
> > >   git-x86 which I stared at for a while then I ran out of time and 
> > >   gave up.
> > 
> > hm, the fix for that is in x86.git already - perhaps you got an older 
> > copy?
> 
> hm, e3c1b141 is already the latest one.

"already in", I assume.


You can always tell what I have by looking at the patch:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/git-x86.patch

It includes the head commit ID at the first line (it's in a
machine-readable form - Matthias's scripts which prepare the mm git tree
actually get the git-foo.patch info direct from the original repo rather
than by applying the diff from broken-out/)

Still.  The crash is 100% repeatable and is the same every time.  Happens
on both my i386 test boxes.

http://userweb.kernel.org/~akpm/config-sony.txt
http://userweb.kernel.org/~akpm/config-vmm.txt

and I bisected it down to e3c1b141.
