Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYEORm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYEORm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYEORmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:42:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46408 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751432AbYEORmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:42:16 -0400
Date: Thu, 15 May 2008 10:42:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Chinner <dgc@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
In-Reply-To: <20080512002403.GP103491721@sgi.com>
Message-ID: <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com>
 <20080512002403.GP103491721@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008, David Chinner wrote:

> If you are going to clean bufferheads (or pages), please clean entire
> mappings via ->writepages as it leads to far superior I/O patterns
> and a far higher aggregate rate of page cleaning.....

That brings up another issue: Lets say I use writepages on a large file 
(couple of gig). How much do you want to write back?

