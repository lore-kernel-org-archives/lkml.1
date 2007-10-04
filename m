Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbXJDMZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbXJDMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXJDMZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:25:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:55919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbXJDMZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:25:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [13/18] x86_64: Allow fallback for the stack
Date: Thu, 4 Oct 2007 14:25:43 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, travis@sgi.com
References: <20071004035935.042951211@sgi.com> <200710041356.51750.ak@suse.de> <1191499692.22357.4.camel@twins>
In-Reply-To: <1191499692.22357.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710041425.43343.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The order-1 allocation failures where GFP_ATOMIC, because SLUB uses !0
> order for everything.

slub is wrong then. Can it be fixed?

> Kernel stack allocation is GFP_KERNEL I presume. 

Of course.

> Also, I use 4k stacks on all my machines.

You don't have any x86-64 machines?

-Andi
