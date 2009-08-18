Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZHRNMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZHRNMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZHRNMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:12:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:38751 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZHRNMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:12:49 -0400
Date: Tue, 18 Aug 2009 15:12:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] page-allocator: Split per-cpu list into one-list-per-migrate-type
Message-ID: <20090818131248.GR9962@wotan.suse.de>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-2-git-send-email-mel@csn.ul.ie> <20090818114335.GO9962@wotan.suse.de> <20090818131024.GD31469@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818131024.GD31469@csn.ul.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 02:10:24PM +0100, Mel Gorman wrote:
> On Tue, Aug 18, 2009 at 01:43:35PM +0200, Nick Piggin wrote:
> > On Tue, Aug 18, 2009 at 12:16:00PM +0100, Mel Gorman wrote:
> Tell me about it. The dcache overhead of this is a problem although I
> tried to limit the damage using pahole to see how much padding I had to
> play with and staying within it where possible.
> 
> > But no I think this is a good idea.
> > 
> 
> Thanks. Is that an Ack?

Sure, your numbers seem OK. I don't know if there is much more you
can do without having it merged somewhere...

Acked-by: Nick Piggin <npiggin@suse.de>


