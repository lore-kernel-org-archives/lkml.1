Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbZCZWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbZCZWgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759049AbZCZWf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:35:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758846AbZCZWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:35:57 -0400
Date: Thu, 26 Mar 2009 15:27:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Matthew Garrett <mjg@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] Make relatime default
In-Reply-To: <20090326184838.26166549@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu>
 <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org>
 <20090326184838.26166549@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Alan Cox wrote:
> 
> NAK this again

And I don't care.

If the distro's had done this right in the year+ that this has been in, I 
m ight consider your NAK to have some weight.

As it is, we know that didn't happen, and we've had three different people 
from different distributions say that they wanted to use relatime anyway, 
so it's now the default in my git tree. 

If you want to live in some dark ages, you can do so with the 
"strictatime" thing.

			Linus
