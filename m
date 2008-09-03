Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYICSpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYICSpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYICSoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:44:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbYICSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:44:12 -0400
Date: Wed, 3 Sep 2008 14:44:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080903184408.GC16175@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain> <20080827200413.GA31324@x200.localdomain> <20080903121103.232E4154228@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903121103.232E4154228@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 05:11:03AM -0700, Roland McGrath wrote:
> > 5. Dummy in examiner -- not used (of course!)
> 
> (Of course, that's why it's called that!)  I found I had to add that or
> the kerneldoc magic would freak out.  The type name is used by users of
> the API, so I wanted to have it documented with description text, but
> its contents are all private to the utrace implementation.  When I had
> no magic /* public: */ comment or no fields declared after it, the 'make
> htmldocs' et al process would barf.

Sounds like kerneldoc wants a fix for this.  And btw, I don't think
half-private structures are a good idea.  Either make it completely
private by just providing a forward declaration in the header, or
put all members in the public definition with a comment describing
they are not for users.  We don't have the arguments of ABI problems
or hiding visibility for maintaince reasons e.g. library APIs have.

