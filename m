Return-Path: <linux-kernel-owner+w=401wt.eu-S935643AbXHHRDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935643AbXHHRDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbXHHRDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:03:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34467 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbXHHRDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:03:44 -0400
Date: Wed, 8 Aug 2007 10:03:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Lee.Schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
In-Reply-To: <20070808164944.GA974@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708081002470.12640@schroedinger.engr.sgi.com>
References: <20070802172118.GD23133@skynet.ie> <200708040002.18167.ak@suse.de>
 <20070806121558.e1977ba5.akpm@linux-foundation.org> <200708062231.49247.ak@suse.de>
 <20070806215541.GC6142@skynet.ie> <20070806221252.aa1e9048.akpm@linux-foundation.org>
 <20070807165546.GA7603@skynet.ie> <20070807111430.f35c03c0.akpm@linux-foundation.org>
 <20070808164944.GA974@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Mel Gorman wrote:

> Despite a fairly specific case, I'd still like to get the problem fixed
> for 2.6.23. I've posted up an alternative fix under the subject "Use one
> zonelist per node instead of multiple zonelists v2". It's a more invasive
> fix although arguably it's better overall than the hack because it's not
> dealing with a specific special case and has a sensible path forward that
> makes policies a saner ultimately. However, unlike the hack it affects all
> callers of the page allocator so lets see what the reaction from reviewers
> is before forgetting about the hack altogether.

Well its more a precursor to things to come than a hack. If the tests go 
well for the single zonelist scheme then we may end up doing what the 
patch did for the mpol_bind zonelists for all allocations.

