Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXEUXqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXEUXqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbXEUXqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:46:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60591 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754977AbXEUXqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:46:09 -0400
Date: Mon, 21 May 2007 16:46:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <Pine.LNX.4.64.0705211524060.29480@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705211639470.23823@schroedinger.engr.sgi.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
 <20070521190043.GA4705@kernel.dk> <Pine.LNX.4.64.0705211208270.27129@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705212026080.5442@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211524060.29480@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Christoph Lameter wrote:

> So I guess the issue is that lockdep does a slab alloc while we get the 
> slab lock during slab alloc?

Lockdep is not available on IA64 where I would be able to figure it out 
using a simulator. x86_64 early printk support seems to be broken? 
No output with earlyprintk=serial.
