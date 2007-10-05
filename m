Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbXJEGZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbXJEGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXJEGZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:25:19 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:35746 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbXJEGZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:25:17 -0400
Date: Fri, 5 Oct 2007 08:25:13 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Peter Staubach <staubach@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
 client git tree...
Message-ID: <20071005082513.4b5a058c@poseidon.drzeus.cx>
In-Reply-To: <47054205.8000908@redhat.com>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	<20071004085206.0a8e37b5@poseidon.drzeus.cx>
	<1191506450.6685.17.camel@heimdal.trondhjem.org>
	<20071004184304.6e71ab6d@poseidon.drzeus.cx>
	<20071004114243.3161af16.akpm@linux-foundation.org>
	<1191525363.6739.12.camel@heimdal.trondhjem.org>
	<47054205.8000908@redhat.com>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 15:41:57 -0400
Peter Staubach <staubach@redhat.com> wrote:

> 
> I would agree.  The 64 bit fileids will only become visible when
> the server is exporting file systems which contain fileids which
> are bigger than 32 bits and then only when the application
> encounters these files.
> 

Or, as has been pointed out, when the server is not the Linux in-kernel
NFS server.

> Also, these 32-bit legacy applications are going to have a
> problem if they are ever run on a system which contains local
> file systems which expose the large fileids.
> 

Agreed. And I'd probably like a way around that as well. But local
files have never worked, NFS has. So removing it from NFS (where it is
more likely to occur IMO) would be a regression.

> It would be better to identify these applications and get them
> fixed.  The world is evolving and it is time for them to do so.
> 

Print a warning or something so that they can be found. Don't go
breaking systems left and right. People have better things to do than
to fix the build systems for ever program they use.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
