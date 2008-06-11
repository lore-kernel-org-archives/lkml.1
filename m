Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbYFKEmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbYFKEmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYFKElr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:41:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37974 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbYFKElq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:41:46 -0400
Date: Tue, 10 Jun 2008 21:40:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
In-Reply-To: <20080611031822.GA8228@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com>
References: <20080605094300.295184000@nick.local0.net>
 <20080605094826.128415000@nick.local0.net> <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com>
 <20080611031822.GA8228@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, Nick Piggin wrote:

> > This is reversing the modification to make get_page_unless_zero() usable 
> > with compound page heads. Will break the slab defrag patchset.
> 
> Is the slab defrag patchset in -mm? Because you ignored my comment about
> this change that assertions should not be weakened until required by the
> actual patchset. I wanted to have these assertions be as strong as
> possible for the lockless pagecache patchset.

So you are worried about accidentally using get_page_unless_zero on a 
compound page? What would be wrong about that?



