Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZJGOOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZJGOOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbZJGOOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:14:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203AbZJGOOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:14:11 -0400
Date: Wed, 7 Oct 2009 10:13:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       hch@infradead.org
Subject: Re: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
Message-ID: <20091007141332.GA21320@infradead.org>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <1254809398-8078-6-git-send-email-tzanussi@gmail.com> <20091006130059.GD15320@elte.hu> <1254888565.28917.135.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254888565.28917.135.camel@tropicana>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 11:09:25PM -0500, Tom Zanussi wrote:
> > I think we also want to have a 'perf -s *' kind of thing to get a list 
> > of all available language modules.
> > 
> 
> I knew somebody would point that out (and suggest a better way ;-)  That
> all makes sense - I'll make these changes in the next version.

I'm a bit worried about linking two million scripting language into the
main perf binary.  Can't we just have seaprate perlperf / pythonperf,
rubyperf, awkperf binaries that only contain the scripting support?

