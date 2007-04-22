Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbXDVMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbXDVMOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXDVMOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:14:38 -0400
Received: from mail.suse.de ([195.135.220.2]:42216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbXDVMOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:14:37 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Fix potential overflow in perfctr reservation
Date: Sun, 22 Apr 2007 14:14:32 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200704172359.l3HNxAMV024586@hera.kernel.org> <20070422010917.6427e7a2.akpm@linux-foundation.org>
In-Reply-To: <20070422010917.6427e7a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221414.32946.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> The created a warning storm:

Hmm, yes good idea to fix that. Probably for x86-64 too.

> 
> I worry rather a lot about how well runtime tested this very late change
> was, 

I tested it with oprofile and checked the nmi watchdog.

> and whether it works correctly even with this fix applied.  Perhaps 
> we should jsut revert?

Then you get the memory corruption back.

The change really only enlarges the bitmaps a little anyways, it does not
change any algorithms.

-Andi
 
 

