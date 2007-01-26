Return-Path: <linux-kernel-owner+w=401wt.eu-S1030825AbXAZIqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030825AbXAZIqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 03:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXAZIqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 03:46:05 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:30669 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030825AbXAZIqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 03:46:04 -0500
Subject: Re: [PATCH] nfs: fix congestion control -v4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, pj@sgi.com
In-Reply-To: <20070125220457.a761ae6a.akpm@osdl.org>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
	 <20070116135325.3441f62b.akpm@osdl.org> <1168985323.5975.53.camel@lappy>
	 <Pine.LNX.4.64.0701171158290.7397@schroedinger.engr.sgi.com>
	 <1169070763.5975.70.camel@lappy>
	 <1169070886.6523.8.camel@lade.trondhjem.org>
	 <1169126868.6197.55.camel@twins>
	 <1169135375.6105.15.camel@lade.trondhjem.org>
	 <1169199234.6197.129.camel@twins> <1169212022.6197.148.camel@twins>
	 <Pine.LNX.4.64.0701190912540.14617@schroedinger.engr.sgi.com>
	 <1169229461.6197.154.camel@twins>
	 <1169231212.5775.29.camel@lade.trondhjem.org>
	 <1169276500.6197.159.camel@twins>
	 <1169482343.6083.7.camel@lade.trondhjem.org>
	 <1169739148.6189.68.camel@twins> <20070125210950.bcdaa7f6.akpm@osdl.org>
	 <Pine.LNX.4.64.0701252130500.7147@schroedinger.engr.sgi.com>
	 <20070125220457.a761ae6a.akpm@osdl.org>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 09:03:37 +0100
Message-Id: <1169798617.6189.83.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 22:04 -0800, Andrew Morton wrote:
> On Thu, 25 Jan 2007 21:31:43 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Thu, 25 Jan 2007, Andrew Morton wrote:
> > 
> > > atomic_t is 32-bit.  Put 16TB of memory under writeback and blam.
> > 
> > We have systems with 8TB main memory and are able to get to 16TB.
> 
> But I bet you don't use 4k pages on 'em ;)
> 
> > Better change it now.
> 
> yup.

I can change to atomic_long_t but that would make this patch depend on
Mathieu Desnoyers' atomic.h patch series.

Do I send out a -v5 with this, or should I send an incremental patch
once that hits your tree?

