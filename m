Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZETXDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZETXDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZETXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:02:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZETXC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:02:56 -0400
Date: Wed, 20 May 2009 19:02:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/3] tracing: add __print_flags for events
In-Reply-To: <20090520225921.GA15167@infradead.org>
Message-ID: <alpine.DEB.2.00.0905201902060.1080@gandalf.stny.rr.com>
References: <20090515210342.488025506@goodmis.org> <20090515210717.745370400@goodmis.org> <20090518173854.GA30425@infradead.org> <alpine.DEB.2.00.0905201810300.1080@gandalf.stny.rr.com> <20090520225921.GA15167@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 May 2009, Christoph Hellwig wrote:

> On Wed, May 20, 2009 at 06:13:37PM -0400, Steven Rostedt wrote:
> > OK, this may even save space. By passing by parameters we must load all 
> > the parameters before calling the function. Even though this is on the 
> > print side, it is still bloated. I'll convert it to an array.
> 
> Nice, thanks.
> 
> Btw, it would be nice to add a __print_symbolic cousin that looks for
> an exact match in an array.  That way we can also print translations to
> names in a way that can be read from the format file and duplicated
> by userspace apps using the binary trace buffer.

You mean more like a "__print_enumerated"? A backward translation of 
enumerated types to their names.

Perhaps __print_symbolic is a bit nicer name.

-- Steve

