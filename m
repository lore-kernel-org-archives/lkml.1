Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZGGH3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZGGH3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZGGH3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:29:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZGGH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:29:13 -0400
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <20090706174700.GT2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de>
	 <20090706172241.GA26042@infradead.org>
	 <20090706174700.GT2714@wotan.suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Jul 2009 09:29:11 +0200
Message-Id: <1246951751.8143.104.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 19:47 +0200, Nick Piggin wrote:
> All good points. I don't know what name to use though -- your idea
> of renaming ->truncate then reusing it is nice but people will cry
> about breaking external modules. I'll call it ->setsize and defer
> having to think about it for now.

Changing the function signature should get them a compiler warning,
aside from that I don't think we should really consider their feelings
anyway ;-)
