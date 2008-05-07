Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbYEGTpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbYEGTpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbYEGTpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:45:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbYEGTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:45:11 -0400
Date: Wed, 7 May 2008 12:44:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507192425.GC19219@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0805071243330.3024@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu>
 <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org> <20080507181714.GA14980@elte.hu> <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org> <20080507184304.GA15554@elte.hu> <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org>
 <20080507192425.GC19219@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Matthew Wilcox wrote:
> 
> One patch I'd still like Yanmin to test is my one from yesterday which
> removes the BKL from fs/locks.c.

And I'd personally rather have the network-fs people test and comment on 
that one ;)

I think that patch is worth looking at regardless, but the problems with 
that one aren't about performance, but about what the implications are for 
the filesystems (if any)...

		Linus
