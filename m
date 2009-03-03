Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZCCNPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZCCNPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZCCNPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:15:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZCCNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:15:33 -0500
Date: Tue, 3 Mar 2009 08:15:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
Message-ID: <20090303131528.GB10931@infradead.org>
References: <20090227203425.F3B51176@kernel> <20090227203431.D1E697CB@kernel> <20090228205329.GB4254@infradead.org> <1236013556.26788.466.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236013556.26788.466.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 09:05:56AM -0800, Dave Hansen wrote:
> On Sat, 2009-02-28 at 15:53 -0500, Christoph Hellwig wrote:
> > Also the double-use of the op seem not very nice to me.  Is there any
> > real life use case were you would have the operation on a file but
> > sometimes not allow checkpoiting?
> 
> I'm still reaching here...
> 
> I was thinking of /proc.  Opening your own /proc/$$/* would certainly be
> considered OK.  But, doing it for some other process not in your pid
> namespace would not be OK and would not be checkpointable.
> 
> I know we're not quite in real-life territory here, yet, but I'm still
> thinking.

That mighr be a good enough excuse, I was just wondering what the use
case was.

