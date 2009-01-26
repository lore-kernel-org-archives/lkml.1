Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbZAZIsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbZAZIsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZAZIs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:48:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39593 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZAZIs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:48:28 -0500
Subject: Re: [patch] SLQB slab allocator (try 2)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090123154653.GA14517@wotan.suse.de>
References: <20090123154653.GA14517@wotan.suse.de>
Date: Mon, 26 Jan 2009 10:48:26 +0200
Message-Id: <1232959706.21504.7.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Fri, 2009-01-23 at 16:46 +0100, Nick Piggin wrote:
> Since last time, fixed bugs pointed out by Hugh and Andi, cleaned up the
> code suggested by Ingo (haven't yet incorporated Ingo's last patch).
> 
> Should have fixed the crash reported by Yanmin (I was able to reproduce it
> on an ia64 system and fix it).
> 
> Significantly reduced static footprint of init arrays, thanks to Andi's
> suggestion.
> 
> Please consider for trial merge for linux-next.

I merged a the one you resent privately as this one didn't apply at all.
The code is in topic/slqb/core branch of slab.git and should appear in
linux-next tomorrow.

Testing and especially performance testing is welcome. If any of the HPC
people are reading this, please do give SLQB a good beating as Nick's
plan is to replace both, SLAB and SLUB, with it in the long run. As
Christoph has expressed concerns over latency issues of SLQB, I suppose
it would be interesting to hear if it makes any difference to the
real-time folks.

		Pekka

