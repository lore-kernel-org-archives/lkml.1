Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbZDIVbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbZDIVbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZDIVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:31:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753506AbZDIVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:31:11 -0400
Date: Thu, 9 Apr 2009 14:20:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] Make relatime default
In-Reply-To: <20090409211501.GC3269@elf.ucw.cz>
Message-ID: <alpine.LFD.2.00.0904091419140.4583@localhost.localdomain>
References: <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org>
 <20090326184838.26166549@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain> <20090409194624.GB1403@ucw.cz> <alpine.LFD.2.00.0904091343110.4583@localhost.localdomain> <20090409211501.GC3269@elf.ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Pavel Machek wrote:
> 
> Well, stat() syscall no longer returns sane value in st_atime, while
> all the userland stayed the same; only kernel changed. I believe that
> is ABI change.

No. 

If you want the old abi, use "strictatime" in your /etc/fstime.

No ABI changed. Just the default mount options changed to be what most 
people (especially non-specialists) would likely want.

Deal with it.

		Linus
