Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0CKOGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:06:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:33162 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab0CKOGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:06:08 -0500
Date: Thu, 11 Mar 2010 06:06:23 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: increase CONFIG_NODES_SHIFT max to 10
Message-ID: <20100311140623.GA9346@suse.de>
References: <alpine.DEB.2.00.1003101537330.30724@chino.kir.corp.google.com> <20100311132354.GA26600@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311132354.GA26600@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 02:23:54PM +0100, Ingo Molnar wrote:
> 
> * David Rientjes <rientjes@google.com> wrote:
> 
> > Some larger systems require more than 512 nodes, so increase the maximum 
> > CONFIG_NODES_SHIFT to 10 for a new max of 1024 nodes.
> > 
> > This was tested with numa=fake=64M on systems with more than 64GB of RAM. A 
> > total of 1022 nodes were initialized.
> > 
> > Successfully builds with no additional warnings on x86_64 allyesconfig.
> 
> Not so here:
> 
> drivers/base/node.c:169: error: negative width in bit-field ?<anonymous>?
> 
> >  Greg KH has queued up numa-fix-BUILD_BUG_ON-for-node_read_distance.patch
> >  for 2.6.35 to fix the build error when CONFIG_NODES_SHIFT is set to 10.
> >  See http://lkml.org/lkml/2010/3/10/390

Well, it will be a few days before I queue it up...

> erm. Alas I cannot merge it in the x86 tree without that fix being upstream. 
> Why for v2.6.35 - shouldnt that be v2.6.34?

If it needs to go in before .35, or it should go through Ingo's trees, I
have no objection.

thanks,

greg k-h
