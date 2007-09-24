Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbXIXSqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbXIXSqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760262AbXIXSp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:45:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57461 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760147AbXIXSp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:45:28 -0400
Date: Mon, 24 Sep 2007 19:45:22 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [patch 4/7] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070924184522.GA5013@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Denys Vlasenko <vda.linux@googlemail.com>
References: <20070924164950.006047409@polymtl.ca> <20070924165427.717587684@polymtl.ca> <20070924174817.GB1608@infradead.org> <20070924184309.GB28347@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924184309.GB28347@Krystal>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 02:43:09PM -0400, Mathieu Desnoyers wrote:
> gcc doesn't like it if I put the attribute after the function in the
> implementation. Should I leave it before or separate the prototype from
> the implementation ?

Just keep it where it was.

> > There seem to be a lot of exports and some functions that don't seem
> > to be used by the obvious marker use-cases like your example, blktrace
> > or sputrace.  Care to explain why we'd really want them or better cut
> > them out for this first submission?
> 
> If you are referring to the exports you just told about in this email,
> I'll remove them, they are not needed. As for the "marker_get_iter" and
> friends, they are used to list the markers (I provide a /proc interface
> to list the markers in the subsequent modules and also use it to dump
> the marker list in a trace channel at trace start so I can later
> understand the event data by using the format strings as type
> identifiers).

Sounds conceptually fine, but can we introduce this together with
the actualy users?
