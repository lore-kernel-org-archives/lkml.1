Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZEHWJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZEHWJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZEHWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:08:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44358 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754490AbZEHWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:08:58 -0400
Date: Fri, 8 May 2009 23:00:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       peterz@infradead.org, riel@redhat.com, linux-kernel@vger.kernel.org,
       tytso@mit.edu, linux-mm@kvack.org, elladan@eskimo.com, npiggin@suse.de,
       cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       minchan.kim@gmail.com
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
 class citizen
Message-ID: <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
In-Reply-To: <20090508125859.210a2a25.akpm@linux-foundation.org>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	<20090430215034.4748e615@riellaptop.surriel.com>
	<20090430195439.e02edc26.akpm@linux-foundation.org>
	<49FB01C1.6050204@redhat.com>
	<20090501123541.7983a8ae.akpm@linux-foundation.org>
	<20090503031539.GC5702@localhost>
	<1241432635.7620.4732.camel@twins>
	<20090507121101.GB20934@localhost>
	<20090507151039.GA2413@cmpxchg.org>
	<20090507134410.0618b308.akpm@linux-foundation.org>
	<20090508081608.GA25117@localhost>
	<20090508125859.210a2a25.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch seems reasonable but the changelog and the (non-existent)
> design documentation could do with a touch-up.

Is it right that I as a user can do things like mmap my database
PROT_EXEC to get better database numbers by making other
stuff swap first ?

You seem to be giving everyone a "nice my process up" hack.

Alan
