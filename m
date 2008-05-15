Return-Path: <linux-kernel-owner+w=401wt.eu-S1750870AbYEOSoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870AbYEOSoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbYEOSno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:43:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59399 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761234AbYEOSnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:43:43 -0400
Date: Thu, 15 May 2008 11:43:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080515181356.GP9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com>
References: <20080510221515.3540a6cc@bree.surriel.com>
 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
 <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
 <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com>
 <20080515181356.GP9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Matthew Wilcox wrote:

> > Details of the crash please?
> 
> I don't have any.

Well the amount of information we are getting has always been the main 
factor in delaying this further and further. Sigh.

> > You could just start with 2.6.25.X which already contains the slab 
> > statistics.
> 
> Certainly.  Exactly how does collecting these stats work?  Am I supposed
> to zero the counters after the TPC has done its initial ramp-up?  What
> commands should I run, and at exactly which points?

Compile slabinfo and then do f.e. slabinfo -AD (this is documented in the 
help text provided when enabling statistics).
