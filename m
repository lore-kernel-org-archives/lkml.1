Return-Path: <linux-kernel-owner+w=401wt.eu-S933896AbYBHScv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896AbYBHScv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbYBHScn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:32:43 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35671 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751119AbYBHScm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:32:42 -0500
Date: Fri, 8 Feb 2008 10:32:41 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Joe Perches <joe@perches.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm/slub.c - Use print_hex_dump
In-Reply-To: <1202495069.27394.85.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802081031320.28862@schroedinger.engr.sgi.com>
References: <1202493808.27394.76.camel@localhost> 
 <Pine.LNX.4.64.0802081006460.28568@schroedinger.engr.sgi.com>
 <1202495069.27394.85.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Joe Perches wrote:

> On Fri, 2008-02-08 at 10:07 -0800, Christoph Lameter wrote:
> > On Fri, 8 Feb 2008, Joe Perches wrote:
> > > Use the library function to dump memory
> > Could you please compare the formatting of the output before and 
> > after? Last time we tried this we had issues because it became a bit ugly.
> 
> The difference is the last line of the ascii is not aligned
> if the length is non modulo 16.
> 
> I have sent a patch to print_hex_dump to always align.
> http://lkml.org/lkml/2007/12/6/304

Could you group these together for review? I think we are okay with the 
slub changes if the print_hex_dump is fixed.

