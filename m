Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZCXSV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZCXSV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZCXSUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:20:17 -0400
Received: from rtr.ca ([76.10.145.34]:33636 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144AbZCXSUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:20:15 -0400
Message-ID: <49C9245C.9040400@rtr.ca>
Date: Tue, 24 Mar 2009 14:20:12 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324133011.GB21720@elte.hu> <20090324135112.GM5814@mit.edu>
In-Reply-To: <20090324135112.GM5814@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> So the question is how quickly can you *dirty* 1.6GB of memory?
..

MythTV:   rm /some/really/huge/video/file ; sync
          ## disk light stays on for several minutes..

Note quite the same thing, I suppose, but it does break
the shutdown scripts of every major Linux distribution.

Simple solution for MythTV is what people already do: use xfs instead.
