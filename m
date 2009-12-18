Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZLRRJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZLRRJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZLRRJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:09:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:36691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbZLRRJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:09:43 -0500
Date: Fri, 18 Dec 2009 08:10:38 -0800
From: Greg KH <gregkh@suse.de>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/6] Driver core: Encourage use of const attributes
Message-ID: <20091218161038.GA19142@suse.de>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <20091217231621.GA5103@suse.de>
 <20091218085221.GD29232@pcarmody-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218085221.GD29232@pcarmody-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 10:52:21AM +0200, Phil Carmody wrote:
> On 18/12/09 00:16 +0100, ext Greg KH wrote:
> > On Thu, Dec 17, 2009 at 08:12:10PM +0200, Phil Carmody wrote:
> [...]> > So here I offer a small patchset which I hope will permit and 
> > > encourage device and other attributes to be made const, and put 
> > > in read-only sections.
> > > 
> > > 1-3 address the three attribute types which seemed to be trivially 
> > > const-able, and are the important part of the set.
> > 
> > I like these, very nice.
> 
> Thanks, I can possibly sniff a little bit deeper, and see if there are
> any other obvious throwing-away-of-consts nearby.

Great.

> > > 4 adds a new macro to encourage the use of Const ATTRibutes,
> > > and may need a better name. (I wanted to avoid RO, for example.)
> > 
> > Hm, is this really needed?  How badly do things break if you change the
> > current attribute macros to use 'const'?  What subsystems are not using
> > const?
> 
> That was the first thing that went through my mind, but I didn't want
> to be too brave. He who dares wins though, and I can certainly give
> that a try. allmodconfig is my friend.

That would be nice to try, let me know what you find.

> > > 5 and 6 are merely two quick examples of how easy it is to adopt 
> > > the new const convention. In reality, these structures have been
> > > constant and treated as constant by the driver core all along, it's
> > > just that one word was missing from a few important places.
> > > 
> > > I would hope to submit a patchset with 1-3 and a possibly modified 
> > > 4. The migrations themselves will belong in different trees.
> > 
> > I'll be glad to take 1-3 now, and queue it up for .34.
> 
> They cleave cleanly at that point, so I'll resend with a [PATCH] prefix.

Got them, I'll go queue them up.

thanks again,

greg k-h
