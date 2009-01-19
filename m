Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZASElA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZASElA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 23:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZASEku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 23:40:50 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:5852 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbZASEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 23:40:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIiRc0l5LBUR/2dsb2JhbADPLYVz
X-IronPort-AV: E=Sophos;i="4.37,286,1231075800"; 
   d="scan'208";a="286865441"
Date: Mon, 19 Jan 2009 15:40:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] async: Add some documentation.
Message-ID: <20090119044045.GA6654@disturbed>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Cornelia Huck <cornelia.huck@de.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20090113174306.0f620476@gondolin> <20090114024952.GS8071@disturbed> <20090114112450.1a1af271@gondolin> <20090118163912.55f835a0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118163912.55f835a0@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 04:39:12PM -0800, Arjan van de Ven wrote:
> On Wed, 14 Jan 2009 11:24:50 +0100
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > > Rather than polishing a turd, can we rename this "special" stuff to
> > > something more descriptive? I'm not the only person to complain
> > > about this. How about async_schedule_list()?
> > > 
> > > After all, async_schedule_list() describes *exactly* how it is
> > > different to async_schedule(), while the "_special" keywords really
> > > suck when you consider code is supposed to be self documenting....
> > 
> > async_schedule_list() sounds better, agreed, but I'd prefer to change
> > that in a seperate patch.
> 
> I had it as that at first. But it is ugly; naming a function after its
> arguments is useless; it should be named after what it does instead.
> 
> I buy that "special" is not a good name. Would "local" be better?
> The name needs to convey that it is for a specific synchronization
> context....

Yeah, local is sounds ok - it's certainly more obvious
that it's a scope modifier for the synchronisation primitive.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
