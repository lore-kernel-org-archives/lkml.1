Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZFIPb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZFIPb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZFIPbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:31:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:38586 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZFIPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:31:18 -0400
Date: Tue, 9 Jun 2009 17:31:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [11/16] HWPOISON: check and isolate corrupted free pages v2
Message-ID: <20090609153119.GA9211@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090603184645.68FA21D0286@basil.firstfloor.org> <20090609100229.GE14820@wotan.suse.de> <20090609130304.GF5589@localhost> <20090609132847.GC15219@wotan.suse.de> <20090609134903.GC6583@localhost> <20090609135514.GD15219@wotan.suse.de> <20090609145614.GA5590@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609145614.GA5590@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 10:56:14PM +0800, Wu Fengguang wrote:
> > Moving hot and cold functions together could become an issue
> > indeed. Mostly it probably matters a little less than code
> > within a single function due to their size. But I think gcc
> > already has options to annotate this kind of thing which we
> > could be using.
> 
> Can we tell gcc "I bet this _function_ is rarely used"?

Yes you can annotate a function as hot or cold.

 
> > So it's not such a good argument against moving things out of
> > hotpaths, or guiding in which files to place functions.
> 
> Yes.
> 
> > Anyway, in this case it is not a "nack" from me. Just that I
> > would like to see the non-fastpath code too or at least if
> > it can be thought about.
> 
> I think Andi would be pleased to present you with his buddy page
> isolation code :)


