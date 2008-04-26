Return-Path: <linux-kernel-owner+w=401wt.eu-S1761780AbYDZTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761780AbYDZTU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYDZTUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:20:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:12273 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYDZTUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WsFLZJx7uHwsl5arCdBm03HncHJcpFJTzTwPgbkQWUkaz4JuZLLAZlY8d95lcXzkFN6Kb/NbOqq6NnXFwgdiszLOJ9g3/glCMFauB+NU5HMlvc90jgOsBY/lmVqZyvF138k4sxAkkxxlOEV7WYtt83gasJx6Ts9vdOzgS3u3Hgs=
Subject: Re: If you want me to quit I will quit
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080426110044.GB2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick>
	 <20080426110044.GB2252@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 12:20:55 -0700
Message-Id: <1209237655.14173.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 14:00 +0300, Adrian Bunk wrote:
> > [BUILDFIX PATCH] au0828: debug is a poor global identifier
> 
> Another issue for which I already sent a (slightly different) patch.
> 
> Why not check the mailing list before duplicating work? [1]
> 

I do generally try to check the mailing list to avoid this...but LKML
tends to be pretty busy.  I also try to check the latest -git devel
tree for the affected area in case it's waiting to be pulled.  In this
case it was so trivial I sent it directly to Linus.

In fact, I concentrate on looking at the sparse output because you
do such a good job of catching unnecessary exports/globals.

> And if you e.g. discover next that our x86 userspace headers in
> 2.6.25 (sic) are fucked up guess who already sent a patch last 
> weekend... [2]
> 
> Why do other people get over 100 checkpatch fixes into the tree at once 
> or Linus applies patches directly bypassing the maintainers (like the 
> one you sent just before [3], which I've also already sent before [4]) 
> but my patches bitrot forever?

And look how many of mine have been sitting in -mm for weeks because I
thought they should go through a maintainer/-mm.  This was just annoying
as it was making my sparse builds quit, and I thought others might be in
the same boat.

Cheers,

Harvey



