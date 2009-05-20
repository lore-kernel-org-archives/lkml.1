Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZETW7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZETW7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZETW7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:59:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZETW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:59:22 -0400
Date: Wed, 20 May 2009 18:59:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/3] tracing: add __print_flags for events
Message-ID: <20090520225921.GA15167@infradead.org>
References: <20090515210342.488025506@goodmis.org> <20090515210717.745370400@goodmis.org> <20090518173854.GA30425@infradead.org> <alpine.DEB.2.00.0905201810300.1080@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905201810300.1080@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 06:13:37PM -0400, Steven Rostedt wrote:
> OK, this may even save space. By passing by parameters we must load all 
> the parameters before calling the function. Even though this is on the 
> print side, it is still bloated. I'll convert it to an array.

Nice, thanks.

Btw, it would be nice to add a __print_symbolic cousin that looks for
an exact match in an array.  That way we can also print translations to
names in a way that can be read from the format file and duplicated
by userspace apps using the binary trace buffer.

