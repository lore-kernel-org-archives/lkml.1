Return-Path: <linux-kernel-owner+w=401wt.eu-S964924AbXBLN5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924AbXBLN5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964925AbXBLN5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:57:53 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:4454 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964924AbXBLN5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:57:52 -0500
Date: Mon, 12 Feb 2007 14:57:49 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Ian Kent <raven@themaw.net>
Cc: "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs protocol somewhere
Message-ID: <20070212135749.GA1681@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Ian Kent <raven@themaw.net>,
	"Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
References: <20070207173414.GA64492@dspnet.fr.eu.org> <1170871661.3415.36.camel@raven.themaw.net> <20070207181817.GA75717@dspnet.fr.eu.org> <1170901990.3383.18.camel@raven.themaw.net> <1171262594.18376.13.camel@raven.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171262594.18376.13.camel@raven.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 03:43:14PM +0900, Ian Kent wrote:
> On Thu, 2007-02-08 at 11:33 +0900, Ian Kent wrote:
> > On Wed, 2007-02-07 at 19:18 +0100, Olivier Galibert wrote:
> > > On Thu, Feb 08, 2007 at 03:07:41AM +0900, Ian Kent wrote:
> > > > It may be better to update to a later kernel so I don't have to port the
> > > > patch to several different kernels. Is that possible?
> > > 
> > > Sure, 2.6.20 or -git?
> > 
> > 2.6.20 has all the patches I've proposed so far except for the one we're
> > working on so that would be best for me.
> > 
> > Seems there may still be a problem with the patch so I'll let you know
> > what's happening as soon as I can.
> 
> I think I'm just about done.
> 
> Could you try using the two patches here against 2.6.20 please:

The patch works beautifully, no more failures with my test rig, until
the point where the kernel crashes.  Since the crashes happen without
the patch too, you're off the hook, but that means I can't deploy it
for harsher testing yet.

No wonder Dave Jones is prudent about updating kernels in fc :-)

  OG.
