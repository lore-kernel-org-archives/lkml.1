Return-Path: <linux-kernel-owner+w=401wt.eu-S1765385AbZFQJnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765385AbZFQJnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765253AbZFQJnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:43:22 -0400
Received: from lucidpixels.com ([75.144.35.66]:48771 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092AbZFQJnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:43:21 -0400
Date: Wed, 17 Jun 2009 05:43:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel
 problem?
In-Reply-To: <4A38ACC0.3060501@msgid.tls.msk.ru>
Message-ID: <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Michael Tokarev wrote:

> Michael Tokarev wrote:
>> Justin Piszcz wrote:
> ...
>
> Justin, by the way, what's the underlying filesystem on the server?
>
> I've seen this error on 2 machines already (both running 2.6.29.x x86-64),
> and in both cases the filesystem on the server was xfs.  May this be
> related somehow to http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?
> That one is different, but also about xfs and nfs.  I'm trying to
> reproduce the problem on different filesystem...
>
> /mjt
>

Hello, I am also running XFS on 2.6.29.x x86-64.

For me, the error happened when I was running an XFSDUMP from a client 
(and dumping) the stream over NFS to the XFS server/filesystem.  This is 
typically when the error occurs or during heavy I/O.

Justin.
