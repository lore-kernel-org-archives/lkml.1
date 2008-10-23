Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYJWSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYJWSL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbYJWSLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:11:09 -0400
Received: from mail.atheros.com ([12.36.123.2]:44244 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbYJWSLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:11:08 -0400
Date: Thu, 23 Oct 2008 04:11:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "otus-devel@lists.madwifi-project.org" 
	<otus-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Release of Atheros 802.11n USB Linux driver
Message-ID: <20081023111103.GB5979@tesla>
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> <20081022065045.GA2400@kroah.com> <20081023062655.GA8039@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081023062655.GA8039@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:26:55PM -0700, Greg KH wrote:
> On Tue, Oct 21, 2008 at 11:50:45PM -0700, Greg KH wrote:
> > On Tue, Oct 21, 2008 at 07:04:17PM -0700, Luis R. Rodriguez wrote:
> > > We would like to see our Atheros 802.11n USB Linux driver upstream
> > > however we need help with this so we are releasing our Atheros 11n USB
> > > Otus Linux driver under the ISC to the community. The goal is to work
> > > with the community to help move this forward upstream. We are hoping
> > > for community help and leadership on this (*cough*).
> >
> > Yeah!
> >
> > I'll grab this and put it in drivers/staging/ so it gets some users and
> > more developers to help out with it.
> 
> Ok, it seems to need some basic work to merely build properly on
> "modern" kernel versions.

Yeah, it works up to 2.6.24.

> So, how should we do this if I want to move it into staging?  Can I just
> take a snapshot of what you have in this repo, move it in-kernel, fix
> the build errors and apply that patch (as your contribution of course)?

That's the thing it needs Wireless Extension support for >= 2.6.24 so
that needs to be done. I can try to do it but first comes ath9k, hence
why we released it to engage with the community on adding that and to
eventually push it upstream.

> Then future development can go off of the in-kernel version?  Or do you
> plan to keep this git tree active somehow?

Yeah so the purpose of the git tree is to collect patches to allow users
to use it with >= 2.6.24, all other focus should be on an in-kernel
driver.

  Luis
