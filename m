Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZLRIwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZLRIwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZLRIwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:52:22 -0500
Received: from smtp.nokia.com ([192.100.105.134]:21066 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZLRIwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:52:20 -0500
Date: Fri, 18 Dec 2009 10:52:21 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Greg KH <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/6] Driver core: Encourage use of const attributes
Message-ID: <20091218085221.GD29232@pcarmody-desktop>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com> <20091217231621.GA5103@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217231621.GA5103@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 Dec 2009 08:51:54.0978 (UTC) FILETIME=[5974AC20:01CA7FBF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/12/09 00:16 +0100, ext Greg KH wrote:
> On Thu, Dec 17, 2009 at 08:12:10PM +0200, Phil Carmody wrote:
[...]> > So here I offer a small patchset which I hope will permit and 
> > encourage device and other attributes to be made const, and put 
> > in read-only sections.
> > 
> > 1-3 address the three attribute types which seemed to be trivially 
> > const-able, and are the important part of the set.
> 
> I like these, very nice.

Thanks, I can possibly sniff a little bit deeper, and see if there are
any other obvious throwing-away-of-consts nearby.

> > 4 adds a new macro to encourage the use of Const ATTRibutes,
> > and may need a better name. (I wanted to avoid RO, for example.)
> 
> Hm, is this really needed?  How badly do things break if you change the
> current attribute macros to use 'const'?  What subsystems are not using
> const?

That was the first thing that went through my mind, but I didn't want
to be too brave. He who dares wins though, and I can certainly give
that a try. allmodconfig is my friend.

> > 5 and 6 are merely two quick examples of how easy it is to adopt 
> > the new const convention. In reality, these structures have been
> > constant and treated as constant by the driver core all along, it's
> > just that one word was missing from a few important places.
> > 
> > I would hope to submit a patchset with 1-3 and a possibly modified 
> > 4. The migrations themselves will belong in different trees.
> 
> I'll be glad to take 1-3 now, and queue it up for .34.

They cleave cleanly at that point, so I'll resend with a [PATCH] prefix.

Many thanks, and seasons greetings,

Phil
