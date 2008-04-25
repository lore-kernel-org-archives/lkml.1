Return-Path: <linux-kernel-owner+w=401wt.eu-S1763695AbYDYRk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763695AbYDYRk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbYDYRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:40:13 -0400
Received: from main.gmane.org ([80.91.229.2]:48390 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760107AbYDYRkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:40:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: x86: 4kstacks default
Date: Fri, 25 Apr 2008 17:39:53 +0000 (UTC)
Message-ID: <loom.20080425T172649-672@post.gmane.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419104911.07d299ef.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.60.35.179 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm <at> linux-foundation.org> writes:

> 
> > On Sat, 19 Apr 2008 16:23:29 +0200 Ingo Molnar <mingo <at> elte.hu> wrote:
> > 
> > * Andrew Morton <akpm <at> linux-foundation.org> wrote:
> > 
> > > >  config 4KSTACKS
> > > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > > -	depends on DEBUG_KERNEL
> > > >  	depends on X86_32
> > > > +	default y
> > > 
> > > This patch will cause kernels to crash.
> > 
> > what mainline kernels crash and how will they crash?
> 
> There has been a dribble of reports - I don't have the links handy, nor did
> I search for them.
> 
> > Fedora and other 
> > distros have had 4K stacks enabled for years:
> > 
> >   $ grep 4K /boot/config-2.6.24-9.fc9
> >   CONFIG_4KSTACKS=y

Here is a report - Fedora 8 default kernel, Mac Mini file server, Not Tainted. 
Attempt to copy 100Gb+ of data from a hfsplus file system on a USB drive to a 
firewire drive with XFS filesystem - I got a nasty panic with a huge stack 
backtrace. I gave up and switched to Ubuntu. With a stock kernel.org kernel I 
was able to successfully copy the data over. I still have the machine and the 
restored drives and can try to reproduce it with Fedora 9 w/4K stacks if 
anyone thinks it is worthwhile (i.e. fixable).

Parag

