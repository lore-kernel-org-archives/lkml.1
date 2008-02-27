Return-Path: <linux-kernel-owner+w=401wt.eu-S1765763AbYB0Hjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765763AbYB0Hjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765367AbYB0HjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:39:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:57338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765332AbYB0HjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:39:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=Ml3jPZLgg4ecvLepQjsBHsUK81qiIOfQPGFHtph9vMw1L+R7drWFppaUXmUyHczgG
	eUM7b9vDf6p1mUzBNuRzQ==
Date: Tue, 26 Feb 2008 23:38:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline
 __attribute__((format (printf,x,y) to statement expression macros
In-Reply-To: <1204095249.19319.444.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802262319350.11433@chino.kir.corp.google.com>
References: <1204081722.19319.405.camel@localhost>  <1204084947.19319.411.camel@localhost>  <20080227041316.GA23188@parisc-linux.org>  <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com> <1204095249.19319.444.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Joe Perches wrote:

> > I'm not seeing any change in text size with allyesconfig after applying 
> > this patch with latest git:
> 
> This is just x86 defconfig
> 

allyesconfig should be able to capture any text savings that this patch 
offers.

> > Joe, what version of gcc are you using?
> 
> $ gcc --version
> gcc (GCC) 4.2.2 20071128 (prerelease) (4.2.2-3.1mdv2008.0)
> 

My x86_64 defconfig with gcc 4.0.3 had no difference in text size after 
applying your patch, yet the same config on gcc 4.1.2 did:

	   text	   data	    bss	    dec	    hex	filename
	5386112	 846328	 719560	6952000	 6a1440	vmlinux.before
	5386048	 846328	 719560	6951936	 6a1400	vmlinux.after
