Return-Path: <linux-kernel-owner+w=401wt.eu-S1765213AbXEUTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765213AbXEUTNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbXEUTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:13:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46260 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756759AbXEUTNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:13:08 -0400
Date: Mon, 21 May 2007 12:13:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Hugh Dickins <hugh@veritas.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070521190043.GA4705@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705211208270.27129@schroedinger.engr.sgi.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
 <20070521190043.GA4705@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Jens Axboe wrote:

> I can test whatever you want tomorrow morning, it was 100% repeatable
> here. So which one, your patch or Hughs?

This was an effect of me suggesting to switch off CONFIG_SLUB_DEBUG. If 
you did not run without CONFIG_SLUB_DEBUG then you were not affected by 
the problem. And the earlier case that you reported was a version of SLUB 
that did not have the capability to switch off SLUB_DEBUG.

Is there any way we can boot with "slub_debug" on the kernel command line 
and get early printk output? Looks like an early failure that may have to 
do with other kernel debug options being on (lockdep or so?)

