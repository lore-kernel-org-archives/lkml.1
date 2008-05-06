Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbYEFHrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbYEFHrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYEFHr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:47:27 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2009 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbYEFHr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:47:26 -0400
Date: Tue, 6 May 2008 08:46:55 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, sam@ravnborg.org, viro@ftp.linux.org.uk,
       hpa@zytor.com
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches (was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080506074636.GA27480@shadowen.org>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <20080505134252.c82a64f6.akpm@linux-foundation.org> <20080505210712.GD1544@cs181133002.pp.htv.fi> <20080505142604.389f05c6.akpm@linux-foundation.org> <20080505144625.2abc8e63@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505144625.2abc8e63@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 02:46:25PM -0700, Arjan van de Ven wrote:
> On Mon, 5 May 2008 14:26:04 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Actually, we could perhaps do a lot of this at the checkpatch level?
> > If checkpatch sees a global symbol being added and the same patch
> > does not add references to that symbol from a different file then
> > whine.  Obviously this will generate false positives but that's OK.
> 
> or.. doesn't add it to a header file. That might be even more generic;
> (and enforces a "all global functions need a prototype in a header
> somewhere)

That does sound possible.  I am sure it will false positive quite a lot,
but its probabally worth a stab.

-apw
