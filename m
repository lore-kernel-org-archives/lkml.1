Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZCYR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZCYR7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZCYR7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:59:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38983 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753642AbZCYR7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:59:01 -0400
Date: Wed, 25 Mar 2009 17:57:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325175746.71a24bd3@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324041249.1133efb6.akpm@linux-foundation.org>
	<20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The fsync() problem is really annoying, but what is doubly annoying is 
> that sometimes one process doing fsync() (or sync) seems to cause other 
> processes to hickup too. 

Bug #5942 (interaction with anticipatory io scheduler)
Bug #9546 (with reproducer & logs)
Bug #9911 including a rather natty tester (albeit in java)
Bug #7372 (some info and figures on certain revs it seemed to get worse)
Bug #12309 (more info, including kjournald hack fix using ioprio)

General consensus seems to be 2.6.18 is where the manure intersected with
the air impeller
