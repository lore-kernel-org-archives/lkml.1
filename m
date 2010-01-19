Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0ASMIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0ASMIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638Ab0ASMIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:08:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0ASMIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:08:13 -0500
Date: Tue, 19 Jan 2010 14:07:12 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100119120712.GM14345@redhat.com>
References: <20100118141938.GI30698@redhat.com>
 <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
 <20100118170816.GA22111@redhat.com>
 <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
 <20100118181942.GD22111@redhat.com>
 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
 <20100119071734.GG14345@redhat.com>
 <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
 <20100119075205.GI14345@redhat.com>
 <20100119115442.131efa78@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119115442.131efa78@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 11:54:42AM +0000, Alan Cox wrote:
> > In my case (virtualization) I want to test/profile guest under heavy swapping
> > of a guests memory, so I intentionally create memory shortage by creating
> > guest much large then host memory, but I want system to swap out only
> > guest's memory.
> 
> So this isn't an API question this is an obscure corner case testing
> question.
> 
It is real use case scenario where the kernel doesn't provider me with
enough rope. You, of course, can dismiss it as "obscure corner case". You
can't expect issues with mlockall() which is corner case by itself to be
mainstream, can you?

> > > 
> > > It would be probably useful if you could point us to the application
> > > source code that actually wants this feature.
> > > 
> > This is two line patch to qemu that calls mlockall(MCL_CURRENT|MCL_FUTURE)
> > at the beginning of the main() and changes guest memory allocation to
> > use MAP_UNLOCKED flag. All alternative solutions in this thread suggest
> > that I should rewrite qemu + all library it uses. You see why I can't
> > take them seriously?
> 
> And you want millions of users to have kernels with weird extra functions
> whole sole value is one test environment you wish to run
> 
We are talking about 4 lines of code that other people find useful too
and they commented in this thread. This wouldn't be the first kernel
feature not used by millions of people.

> See why we can't take you seriously either ?
> 
I was taking about solutions. Thank you.

--
			Gleb.
