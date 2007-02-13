Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbXBMAwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbXBMAwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXBMAwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:52:01 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52469 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933014AbXBMAwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:52:00 -0500
X-Sasl-enc: KVJYSTKsC4WUvco8jmHw3Nj99ZNsZ/5XkXEghmEIDWfi 1171327916
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs
	protocol somewhere
From: Ian Kent <raven@themaw.net>
To: Olivier Galibert <galibert@pobox.com>
Cc: "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <20070212135749.GA1681@dspnet.fr.eu.org>
References: <20070207173414.GA64492@dspnet.fr.eu.org>
	 <1170871661.3415.36.camel@raven.themaw.net>
	 <20070207181817.GA75717@dspnet.fr.eu.org>
	 <1170901990.3383.18.camel@raven.themaw.net>
	 <1171262594.18376.13.camel@raven.themaw.net>
	 <20070212135749.GA1681@dspnet.fr.eu.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 09:52:39 +0900
Message-Id: <1171327959.3377.3.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 14:57 +0100, Olivier Galibert wrote:
> On Mon, Feb 12, 2007 at 03:43:14PM +0900, Ian Kent wrote:
> > On Thu, 2007-02-08 at 11:33 +0900, Ian Kent wrote:
> > > On Wed, 2007-02-07 at 19:18 +0100, Olivier Galibert wrote:
> > > > On Thu, Feb 08, 2007 at 03:07:41AM +0900, Ian Kent wrote:
> > > > > It may be better to update to a later kernel so I don't have to port the
> > > > > patch to several different kernels. Is that possible?
> > > > 
> > > > Sure, 2.6.20 or -git?
> > > 
> > > 2.6.20 has all the patches I've proposed so far except for the one we're
> > > working on so that would be best for me.
> > > 
> > > Seems there may still be a problem with the patch so I'll let you know
> > > what's happening as soon as I can.
> > 
> > I think I'm just about done.
> > 
> > Could you try using the two patches here against 2.6.20 please:
> 
> The patch works beautifully, no more failures with my test rig, until
> the point where the kernel crashes.  Since the crashes happen without
> the patch too, you're off the hook, but that means I can't deploy it
> for harsher testing yet.
> 
> No wonder Dave Jones is prudent about updating kernels in fc :-)

Indeed.
Which kernel can you use?
I believe that 2200 had another problem so can you use an fc5 kernel
later than that?

Ian


