Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbZASM2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbZASM2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZASM2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:28:43 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:36047 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbZASM2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:28:42 -0500
Date: Mon, 19 Jan 2009 13:27:44 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] async: Add some documentation.
Message-ID: <20090119132744.0beee067@gondolin>
In-Reply-To: <20090119044045.GA6654@disturbed>
References: <20090113174306.0f620476@gondolin>
	<20090114024952.GS8071@disturbed>
	<20090114112450.1a1af271@gondolin>
	<20090118163912.55f835a0@infradead.org>
	<20090119044045.GA6654@disturbed>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 15:40:45 +1100,
Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Jan 18, 2009 at 04:39:12PM -0800, Arjan van de Ven wrote:
> > On Wed, 14 Jan 2009 11:24:50 +0100
> > Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > 
> > > > Rather than polishing a turd, can we rename this "special" stuff to
> > > > something more descriptive? I'm not the only person to complain
> > > > about this. How about async_schedule_list()?
> > > > 
> > > > After all, async_schedule_list() describes *exactly* how it is
> > > > different to async_schedule(), while the "_special" keywords really
> > > > suck when you consider code is supposed to be self documenting....
> > > 
> > > async_schedule_list() sounds better, agreed, but I'd prefer to change
> > > that in a seperate patch.
> > 
> > I had it as that at first. But it is ugly; naming a function after its
> > arguments is useless; it should be named after what it does instead.
> > 
> > I buy that "special" is not a good name. Would "local" be better?
> > The name needs to convey that it is for a specific synchronization
> > context....
> 
> Yeah, local is sounds ok - it's certainly more obvious
> that it's a scope modifier for the synchronisation primitive.

Hm, I don't like _local too much. How about _subset, or _context, or
_scope?
