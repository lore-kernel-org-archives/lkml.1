Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbXL1MxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbXL1MxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 07:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXL1MxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 07:53:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:34779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbXL1MxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 07:53:11 -0500
From: Andi Kleen <ak@suse.de>
To: travis@sgi.com
Subject: Re: [PATCH 05/10] x86_64: Use generic percpu
Date: Fri, 28 Dec 2007 13:54:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com
References: <20071228001046.854702000@sgi.com> <20071228001047.556634000@sgi.com>
In-Reply-To: <20071228001047.556634000@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712281354.52453.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007 01:10:51 travis@sgi.com wrote:
> x86_64 provides an optimized way to determine the local per cpu area
> offset through the pda and determines the base by accessing a remote
> pda.

And? The rationale for this patch seems to be incomplete.

As far as I can figure out you're replacing an optimized percpu 
implementation which a dumber generic one. Which needs
at least some description why.

If the generic one is now as good or better than the 
specific one that might be ok, but that should be somewhere
in the description.

Also for such changes .text size comparisons before/after
are a good idea.

-Andi
 
