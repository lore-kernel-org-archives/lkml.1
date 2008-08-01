Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbYHAUJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbYHAUJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbYHAUJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:09:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753281AbYHAUJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:09:04 -0400
Date: Fri, 1 Aug 2008 15:09:01 -0500
From: Jack Steiner <steiner@sgi.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Robin Holt <holt@sgi.com>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GRU driver feedback
Message-ID: <20080801200901.GA167958@sgi.com>
References: <20080723141229.GB13247@wotan.suse.de> <20080729185315.GA14260@sgi.com> <200807301550.34500.nickpiggin@yahoo.com.au> <200807311714.05252.nickpiggin@yahoo.com.au> <20080731124039.GA27329@sgi.com> <Pine.LNX.4.64.0808011305080.20052@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808011305080.20052@blonde.site>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 01:11:09PM +0100, Hugh Dickins wrote:
> On Thu, 31 Jul 2008, Jack Steiner wrote:
> > 
> > I'm collecting the fixes & additional comments to be added & will send
> > them upstream later.
> 
> One small thing to remove if you've not already noticed:
> EXPORT_SYMBOL_GPL(follow_page) got added to mm/memory.c,
> despite our realization that GRU cannot and now does not use it.
> 

Thanks for catching this. I sent a patch upstream a few minutes ago to
remove the export.

--- jack
