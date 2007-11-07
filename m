Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbXKGSEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbXKGSEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXKGSEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:04:22 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40251 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbXKGSEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:04:21 -0500
Date: Wed, 7 Nov 2007 10:04:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/23] Slab defragmentation V6
In-Reply-To: <1194424650.6289.109.camel@twins>
Message-ID: <Pine.LNX.4.64.0711071003060.9000@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <1194424650.6289.109.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Peter Zijlstra wrote:

> On Tue, 2007-11-06 at 17:11 -0800, Christoph Lameter wrote:
> > Slab defragmentation
> 
> I thought we had agreed that: targeted reclaim, was a more suitable term
> for this work as it does not do compaction.

It does compaction by removing less populated slabs. If a kick method 
reallocates the object instead of reclaiming it then this patchset fully 
support compaction. Its just that the kick methods are simplistic at this 
point.

