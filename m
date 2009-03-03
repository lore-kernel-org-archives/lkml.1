Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZCCHbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZCCHbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbZCCHbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:31:35 -0500
Received: from kroah.org ([198.145.64.141]:35045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751139AbZCCHbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:31:34 -0500
Date: Mon, 2 Mar 2009 23:30:45 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: Staging, place holder for better company/community development
	model
Message-ID: <20090303073045.GA4528@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 11:14:56PM -0800, Luis R. Rodriguez wrote:
> A lot of people really hate the staging tree.

They do?  I've not gotten any complaints that I can remember about it.

> I don't but let me tell you why and I'd like to see if you concur with
> these particular concrete use cases and ideas on how to further use
> it.
> 
> The ath9k driver came to many as a big surprise -- and since it was a
> surprise we had to do the work ourselves as a team at Atheros in
> closed doors, without the community's involvement until we got
> something standing up and not smelling as bad. Our own change in
> direction to work on things upstream can be seen later as well by the
> release of the 11n Otus driver and documentation provided to
> interested developers to port it to mac80211 (not to mention similar
> type of work for ath5k) -- Johannes quickly then ported it and created
> the ar9170 11n USB driver which is its replacement for otus and
> targeted for wireless-testing. Otus is currently part of the staging
> tree. While ar9170 has no 802.11n support users wishing to test 11n
> USB with an open driver can use the "vendor" driver. The idea is to
> minimize as time goes by the "port" effort and get things out to the
> community faster.
> 
> With future devices we may want to create a better path for
> integration into upstream drivers. But I also want users to get
> support for the devices as soon as those devices hit shelves in the
> market, maybe even before. So I would like to think of staging not
> only as a place for people to put drivers which a company has no
> resources to do the right job but also perhaps to _do_ the actual port
> work _with_ the community together.

This is already happening today, with at least two different network
drivers, so I have no objection to this at all.

> By doing so we get devices supported with whatever ugly piece of code
> makes the device run (as long as its open, upstreamble, etc) but we
> also can engage with the community on the actual engineering and
> future of the actual driver we do want to support in Linux.
> 
> As time goes by hopefully staging will not be necessary as companies
> (like ours) will have an immediate well defined structure for their
> drivers to easily add support for further devices.

Sounds fine to me.

> If we should take this approach -- should we send patches for wireless
> staging to John, or Greg? It would still be "crap" so I don't expect
> John to accept to help maintain crap but what if its crap with a clear
> defined path to un-crap land?

I'll gladly take them, no objections from me.

thanks,

greg k-h
