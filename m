Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYBKPtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYBKPtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYBKPsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:48:54 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43962 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbYBKPsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:48:53 -0500
Date: Mon, 11 Feb 2008 21:19:19 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Hellwig <hch@infradead.org>, sam@ravnborg.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 8/8] Move RODATA and NX tests to tests/
Message-ID: <20080211154919.GA9076@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080211104452.GB7944@in.ibm.com> <20080211105229.GJ7944@in.ibm.com> <20080211144205.GA26943@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211144205.GA26943@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 03:42:05PM +0100, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > Move RODATA and NX testcases to tests/
> 
> i'm not sure this is the proper place for it - it's highly x86 specific. 
> arch/x86/tests sounds like the better place for it.

Right. I wasn't sure of it and so made these depend on CONFIG_X86. But
yes, it makes more sense for them to live someplace arch specific.

Ananth
