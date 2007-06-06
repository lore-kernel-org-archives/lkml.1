Return-Path: <linux-kernel-owner+w=401wt.eu-S934747AbXFFSJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934747AbXFFSJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXFFSJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:09:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbXFFSJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:09:45 -0400
Date: Wed, 6 Jun 2007 11:09:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606110931.fda845de.akpm@linux-foundation.org>
In-Reply-To: <20070606161936.GA8952@localhost.localdomain>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<20070606161936.GA8952@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 00:19:36 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:

> On Wed, Jun 06, 2007 at 02:07:37AM -0700, Andrew Morton wrote:
> >
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> >
> >- Somebody broke it on my powerpc G5, but I didn't have time to do yet
> >  another bisection yet.
> >
> 
> It seems strange that a new C source file (mlguest.c) appears in the top dir of the 
> kernel source. There are some problems with it.
> 
> First, I used `make mlguest.o` to compile that file, but I got tons of warnings and errors.
> (Too many to put here.) What's wrong with it? Or I didn't compile/configure it correctly?
> 
> Second, mlguest.c #includes a head file named "../../include/linux/lguest_launcher.h".
> Since mlguest.c is in the top dir, so where is ../../include/linux/lguest_launcher.h?
> 

Confused.  I've grepped the entire universe here for "mlguest" and came up
with nothing.

I don't have a clue where that file came from on your system.
