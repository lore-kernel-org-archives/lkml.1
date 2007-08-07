Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXHGUhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXHGUhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764877AbXHGUha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:37:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43219 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934822AbXHGUh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:37:29 -0400
Date: Tue, 7 Aug 2007 13:37:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@skynet.ie>, Andi Kleen <ak@suse.de>,
       Lee.Schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
In-Reply-To: <20070807111430.f35c03c0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708071334430.3430@schroedinger.engr.sgi.com>
References: <20070802172118.GD23133@skynet.ie> <200708040002.18167.ak@suse.de>
 <20070806121558.e1977ba5.akpm@linux-foundation.org> <200708062231.49247.ak@suse.de>
 <20070806215541.GC6142@skynet.ie> <20070806221252.aa1e9048.akpm@linux-foundation.org>
 <20070807165546.GA7603@skynet.ie> <20070807111430.f35c03c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007, Andrew Morton wrote:

> > It's even more constrained than that. It only applies to the MPOL_BIND
> > policy when kernelcore= is specified. The other policies work the same
> > as they ever did.
> 
> so.. should we forget about merging the horrible-hack?

Support MPOL_BIND is a basic NUMA feature. This is going to make .23 
unusable for us if kernelcore= is used. If we cannot use kernelcore then 
NUMA systems cannot use the features that depend on kernelcore.



