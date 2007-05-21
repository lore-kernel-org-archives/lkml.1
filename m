Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbXEUTEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbXEUTEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbXEUTEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:04:37 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:25348 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbXEUTEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:04:36 -0400
Date: Mon, 21 May 2007 20:04:10 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705212003110.1719@blonde.wat.veritas.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AHNyaWhhcml2aWpheWFyYWdoYXZhbkB5YWhvby5jb20uYXUAb3h5bW9yb25Ad2FzdGUub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBqZW5zLmF4Ym9lQG9yYWNsZS5jb20AYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Christoph Lameter wrote:
> On Mon, 21 May 2007, Hugh Dickins wrote:
> > On Mon, 21 May 2007, Christoph Lameter wrote:
> > > On Mon, 21 May 2007, Hugh Dickins wrote:
> 
> > > SLUB Debug: Fix object size calculation
> > > 
> > > The object size calculation is wrong if !CONFIG_SLUB_DEBUG because
> > > the #ifdef CONFIG_SLUB_DEBUG is now switching off the size adjustments
> > > for DESTROY_BY_RCU and ctor.
> > > 
> > > Signed-off-by: Christoph Lameter <clameter@sgi.com>

Acked-by: Hugh Dickins <hugh@veritas.com>
