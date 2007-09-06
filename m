Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXIFFYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXIFFYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 01:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXIFFXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 01:23:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56584 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbXIFFXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 01:23:54 -0400
X-Sasl-enc: 7uxIcupw/FT+mymrllQL6q1YbON0l10YcED13uaKfDOI 1189056230
Subject: Re: recent nfs change causes autofs regression
From: Ian Kent <raven@themaw.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: David Howells <dhowells@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <1189007414.13235.20.camel@gaula.trondhjem.org>
References: <1188996257.3119.7.camel@raven.themaw.net>
	 <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188577275.6649.133.camel@heimdal.trondhjem.org>
	 <5813.1188892468@redhat.com>   <3558.1189006671@redhat.com>
	 <1189007414.13235.20.camel@gaula.trondhjem.org>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 13:23:43 +0800
Message-Id: <1189056223.3102.99.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 16:50 +0100, Trond Myklebust wrote:
> On Wed, 2007-09-05 at 16:37 +0100, David Howells wrote:
> > Ian Kent <raven@themaw.net> wrote:
> > 
> > > But what about mounting with different protocol, tcp vs udp for example.
> > 
> > I was referring specifically to the R/O / R/W variants of the same mount.  Any
> > flag variation that varies the way the NFS client talks to the NFS server must
> > either result in a new superblock or be ignored.
> > 
> > David
> 
> We currently ignore remount requests that attempt to change the NFS
> mount parameters. This is not new behaviour, BTW: it has always been the
> case, and nobody has ever requested it.

Yes, I only mentioned it because I'm aware it.

I've not payed much attention to it because there haven't been any
complaints so far and it's been a long time.

Ian

