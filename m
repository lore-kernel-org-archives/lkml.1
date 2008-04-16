Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbYDPTXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbYDPTXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765595AbYDPTXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:23:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53711 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765584AbYDPTW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:22:59 -0400
Date: Wed, 16 Apr 2008 12:22:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ross Biro <rossb@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mel@skynet.ie, apm@shadoween.org
Subject: Re: [PATCH 1/2] MM: Make page tables relocatable -- conditional
 flush (rc9)
In-Reply-To: <20080414155702.ca7eb622.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804161221060.14718@schroedinger.engr.sgi.com>
References: <20080414163933.A9628DCA48@localhost>
 <20080414155702.ca7eb622.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Andrew Morton wrote:

> This is a large patch which is quite intrusive on the core memory
> management code.  It appears that there has been close to zero interest
> from any MM developers apart from a bit of to-and-fro back in October. 
> Probably because nobody can see why the chnges are valuable to them, and
> that's probably because you're not telling them!

The patch is interesting because it would allow the moving of page table 
pages into MOVABLE sections and reduce the size of the UNMOVABLE 
allocations signficantly (Ross: We need some numbers here). This in turn 
improves the success of the antifrag methods. May also improve lumpy 
reclaim if it can be adapted to move page table pages out of the way.

