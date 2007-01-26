Return-Path: <linux-kernel-owner+w=401wt.eu-S1030807AbXAZGyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030807AbXAZGyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030808AbXAZGyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:54:10 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:40945 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030807AbXAZGyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:54:06 -0500
Date: Thu, 25 Jan 2007 22:53:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, pj@sgi.com
Subject: Re: [PATCH] nfs: fix congestion control -v4
In-Reply-To: <20070125220457.a761ae6a.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701252251450.11726@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <20070116135325.3441f62b.akpm@osdl.org> <1168985323.5975.53.camel@lappy>
 <Pine.LNX.4.64.0701171158290.7397@schroedinger.engr.sgi.com>
 <1169070763.5975.70.camel@lappy> <1169070886.6523.8.camel@lade.trondhjem.org>
 <1169126868.6197.55.camel@twins> <1169135375.6105.15.camel@lade.trondhjem.org>
 <1169199234.6197.129.camel@twins> <1169212022.6197.148.camel@twins>
 <Pine.LNX.4.64.0701190912540.14617@schroedinger.engr.sgi.com>
 <1169229461.6197.154.camel@twins> <1169231212.5775.29.camel@lade.trondhjem.org>
 <1169276500.6197.159.camel@twins> <1169482343.6083.7.camel@lade.trondhjem.org>
 <1169739148.6189.68.camel@twins> <20070125210950.bcdaa7f6.akpm@osdl.org>
 <Pine.LNX.4.64.0701252130500.7147@schroedinger.engr.sgi.com>
 <20070125220457.a761ae6a.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Andrew Morton wrote:

> > We have systems with 8TB main memory and are able to get to 16TB.
> 
> But I bet you don't use 4k pages on 'em ;)

IA64 can be configured for 4k pagesize but yes 16k is the default. There 
are plans to go much higher though. Plus there may be other reaons that 
will force us to 4k pagesize on some configurations.
