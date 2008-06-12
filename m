Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYFLRN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYFLRN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYFLRNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:13:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60244 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753498AbYFLRNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:13:20 -0400
Date: Thu, 12 Jun 2008 10:13:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: repeatable slab corruption with LTP msgctl08
In-Reply-To: <Pine.LNX.4.64.0806121332130.11556@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0806121011320.30597@schroedinger.engr.sgi.com>
References: <20080611221324.42270ef2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0806121332130.11556@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Pekka J Enberg wrote:

> I really don't understand how your bufctl chains has so many BUFCTL_END 
> elements in the first place. It's doesn't look like the memory has been 
> stomped on (slab->s_mem, for example, is 0xf2906088), so I'd look for a 
> double kfree() of size 128 somewhere...

Looks pretty strange. Could this be rerun with SLAB_DEBUG or with SLUB 
with full debugging?
