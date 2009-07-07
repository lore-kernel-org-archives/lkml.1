Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZGGIss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZGGIss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZGGIsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:48:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:50593 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbZGGIsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:48:39 -0400
Date: Tue, 7 Jul 2009 10:48:41 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
Message-ID: <20090707084841.GY2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <20090706172241.GA26042@infradead.org> <20090706174700.GT2714@wotan.suse.de> <1246951751.8143.104.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246951751.8143.104.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:29:11AM +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-06 at 19:47 +0200, Nick Piggin wrote:
> > All good points. I don't know what name to use though -- your idea
> > of renaming ->truncate then reusing it is nice but people will cry
> > about breaking external modules. I'll call it ->setsize and defer
> > having to think about it for now.
> 
> Changing the function signature should get them a compiler warning,
> aside from that I don't think we should really consider their feelings
> anyway ;-)

Well I don't much, but some people do. Anyway I think ->setsize is
actually quite a good name on 2nd thoughts ;)

