Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXJERyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXJERyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXJERym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:54:42 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:48891 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757533AbXJERyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:54:41 -0400
Date: Fri, 5 Oct 2007 19:54:37 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Peter Staubach <staubach@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
 client git tree...
Message-ID: <20071005195437.2795f15a@poseidon.drzeus.cx>
In-Reply-To: <1191605779.6715.86.camel@heimdal.trondhjem.org>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	<20071004085206.0a8e37b5@poseidon.drzeus.cx>
	<1191506450.6685.17.camel@heimdal.trondhjem.org>
	<20071004184304.6e71ab6d@poseidon.drzeus.cx>
	<20071004114243.3161af16.akpm@linux-foundation.org>
	<1191525363.6739.12.camel@heimdal.trondhjem.org>
	<47054205.8000908@redhat.com>
	<20071005082513.4b5a058c@poseidon.drzeus.cx>
	<1191605779.6715.86.camel@heimdal.trondhjem.org>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 13:36:19 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Fri, 2007-10-05 at 08:25 +0200, Pierre Ossman wrote:
> 
> > Print a warning or something so that they can be found. Don't go
> > breaking systems left and right. People have better things to do
> > than to fix the build systems for ever program they use.
> 
> The kernel knows bugger all about what glibc function your program is
> calling. The problem here is precisely that newer versions of glibc
> will transform legacy 32-bit stat() calls into 64-bit stat64() calls,
> then will complain when the result overflows.
> 

Right, I didn't suggest that this had to be done in the kernel. My
point was that first you mark something as deprecated, make a lot of
noise when someone uses it so that problems can be identified, and some
time later you remove it. You don't just remove it and let production
systems deal with the fallout.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
