Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZC0APB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZC0APB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762655AbZC0AOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:14:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761711AbZC0AOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:14:37 -0400
Date: Thu, 26 Mar 2009 17:11:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-Id: <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<49C88C80.5010803@krogh.cc>
	<72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
	<20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 16:23:08 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 25 Mar 2009, Theodore Tso wrote:
> > > 
> > > The problem being that unlike the ratio, there's no sane default value 
> > > that you can at least argue is not _entirely_ pointless.
> > 
> > Well, if the maximum time that someone wants to wait for an fsync() to
> > return is one second, and the RAID array can write 100MB/sec
> 
> How are you going to tell the kernel that the RAID array can write 
> 100MB/s?
> 
> The kernel has no idea.
> 

userspace can do it quite easily.  Run a self-tuning script after
installation and when the disk hardware changes significantly.

It is very disappointing that nobody appears to have attempted to do
_any_ sensible tuning of these controls in all this time - we just keep
thrashing around trying to pick better magic numbers in the base kernel. 

Maybe we should set the tunables to 99.9% to make it suck enough to
motivate someone.
