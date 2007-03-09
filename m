Return-Path: <linux-kernel-owner+w=401wt.eu-S2992897AbXCICri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992897AbXCICri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992900AbXCICrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:47:37 -0500
Received: from ozlabs.org ([203.10.76.45]:44576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992897AbXCICrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:47:36 -0500
Date: Thu, 8 Mar 2007 20:46:06 -0600
From: Anton Blanchard <anton@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070309024606.GB24695@kryten>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten> <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yeah, I'm not at all surprised. Any implementation of "prefetch" that 
> doesn't just turn into a no-op if the TLB entry doesn't exist (which makes 
> them weaker for *actual* prefetching) will generally have a hard time with 
> a NULL pointer. Exactly because it will try to do a totally unnecessary 
> TLB fill - and since most CPU's will not cache negative TLB entries, that 
> unnecessary TLB fill will be done over and over and over again..

Yeah this is exactly what we were seeing :)

Anton
