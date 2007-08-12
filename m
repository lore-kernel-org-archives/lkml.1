Return-Path: <linux-kernel-owner+w=401wt.eu-S938878AbXHLVAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938878AbXHLVAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937674AbXHLVAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:00:39 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40109
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936926AbXHLVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:00:38 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Date: Sun, 12 Aug 2007 16:00:34 -0500
User-Agent: KMail/1.9.6
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, linux-doc@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200708120045.03032.jesper.juhl@gmail.com> <200708121503.30631.rob@landley.net> <9a8748490708121311m643e85b1p88ba679f7272c411@mail.gmail.com>
In-Reply-To: <9a8748490708121311m643e85b1p88ba679f7272c411@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121600.34424.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 3:11:06 pm Jesper Juhl wrote:
> On 12/08/07, Rob Landley <rob@landley.net> wrote:
> > On Sunday 12 August 2007 7:48:37 am Stefan Richter wrote:
> > > Isn't it with 00-INDEX just like with the "Last Updated:" footers in
> > > documentation texts?
> > >
> > > They are metadata which will be almost always out of date.
> >
> > If nothing is using them, they'll bit-rot, yes.  Way of the world.  But
> > I've found a use for them.  Therefore, I'm interested in getting them up
> > to date and then keeping them there.
>
> So, do you want me to create more of these?

Yes please.

> If you want them, could you perhaps start by ACK'ing the first 5
> patches to help me get them merged?

Just did. :)

> Once I see the first 5 merged I'll start creating more, but I don't
> want to waste time doing so before that.

Sorry it took so long, but my net access is still a touch intermittent just 
now.  I recently moved back to Austin and we haven't unpacked the wireless 
router yet.  (So although there's internet at home my wife is usually the one 
using it.  I'm out at a wireless laundromat at the moment.  Yes, Austin has 
such things.)

> >I already wrote an automatic checker to tell me
> > how they differ from reality, which is half the battle.
>
> I started writing such a script myself yesterday, but it's not done
> yet. If you already have one that works could I have a copy please?
> That would make my life easier if I'm to help you with this.

I posted a link to it in the message at the start of this thread:
http://lkml.org/lkml/2007/8/9/584

Here's the release announcement for it:
http://marc.info/?l=linux-doc&m=118671778606001&w=2

Here's the source control for it:
http://landley.net/hg/kdocs/file/tip/make/

You need to run the index.html generator first, because the link checker works 
on the html and not on 00-INDEX itself.  Both scripts expect Documentation to 
be a subdirectory of the current directory, and do the whole directory.

And I need to update it so it filters out index.html, but my laundry's 
done. :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
