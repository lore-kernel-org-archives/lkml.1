Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbXCEQx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbXCEQx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXCEQx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:53:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58422 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXCEQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:53:25 -0500
Date: Mon, 5 Mar 2007 16:49:51 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       5B 5B Kernel development list 
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
Message-ID: <20070305164951.GA2909@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Roland McGrath <roland@redhat.com>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	5B 5B Kernel development list <linux-kernel@vger.kernel.org>
References: <20070305133639.GA6490@infradead.org> <Pine.LNX.4.44L0.0703051113350.3401-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0703051113350.3401-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 11:16:48AM -0500, Alan Stern wrote:
> > Making this unconditional is pointless and just makes things harder to
> > read, so please don't do it.  (The same is true for utrace, but Roland
> > has unfortunately still not replied to my mail mentioning it :P)
> 
> Sorry, I don't understand what you're saying.  I would think that making
> it _conditional_ would make things harder to read, because of all the
> extra "#ifdef" and "#endif" lines plus the need to keep two different
> versions of the code in mind.
> 
> Did you mean to say "conditional" instead of "unconditional"?

Yes, I did mean that.  Sorry for the confusion :)

> Incidentally, I do believe that for certain applications (embedded
> devices, for instance) it makes sense to avoid including all this code.  
> The cleanest way to do that would be to make both PTRACE and UTRACE
> configurable.

PTRACE configurable makes a lot of sense, especially as we want to get
rid of it very long term.  Making UTRACE configurable aswel as all
these tracehooks wrappers just make the code utterly unreadable.

