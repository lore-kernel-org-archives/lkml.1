Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbXDIStk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbXDIStk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXDIStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:49:39 -0400
Received: from mx1.suse.de ([195.135.220.2]:34291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbXDISti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:49:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [QUICKLIST 3/4] Quicklist support for x86_64
Date: Mon, 9 Apr 2007 20:49:34 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com> <200704092043.14335.ak@suse.de> <Pine.LNX.4.64.0704091144270.8783@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704091144270.8783@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704092049.34317.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It has to be done in sync with tlb flushing.

Why?

> Doing that on memory pressure  
> would complicate things significantly. 

Again why? 

> Also idling means that the cache  
> grows cold.

Does it? Unless you worry about interrupts nothing in idle
is going to thrash caches.

-Andi
 
