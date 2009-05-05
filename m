Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZEEJSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZEEJSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZEEJRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:17:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:34206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZEEJRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:17:51 -0400
Date: Tue, 5 May 2009 11:17:50 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH] SLQB: Coding style cleanups
Message-ID: <20090505091750.GA14181@wotan.suse.de>
References: <Pine.LNX.4.64.0905031514330.32397@melkki.cs.Helsinki.FI> <20090505082545.GE30220@wotan.suse.de> <84144f020905050137k692fb9d6l3f25a03b12b65333@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020905050137k692fb9d6l3f25a03b12b65333@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 11:37:32AM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Tue, May 5, 2009 at 11:25 AM, Nick Piggin <npiggin@suse.de> wrote:
> >> @@ -59,7 +59,7 @@ static inline void struct_slqb_page_wrong_size(void)
> >>  /*
> >>   * slqb_min_order: minimum allocation order for slabs
> >>   */
> >> -static int slqb_min_order = 0;
> >> +static int slqb_min_order;
> >
> > I actually like explicit zero initializers. I think it has been
> > a long time since this actually saved any memory with gcc.
> >
> > Yes yes, I know that anybody who can "read C" will read the
> > implicit zero initializer anyway... however I just think it is
> > a stupid thing for checkpatch to warn against.
> 
> OK. I guess I can drop those hunks. But from coding style of point
> view we don't really do explicit zero initializers in the core
> kernel...

Well... it's not a big deal, but I just don't think it is a big
enough deal to have checkpatch complain about it. Whatever you
like. If you have already committed that version, then don't
worry about changing it.

