Return-Path: <linux-kernel-owner+w=401wt.eu-S1030450AbXAaSBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030450AbXAaSBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030462AbXAaSBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:01:40 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:57394 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030450AbXAaSBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:01:39 -0500
Date: Wed, 31 Jan 2007 18:56:01 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Hollis <dhollis@davehollis.com>
cc: Jeff Garzik <jeff@garzik.org>,
       Trent Waddington <trent.waddington@gmail.com>,
       Dave Airlie <airlied@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
In-Reply-To: <1170250461.12914.33.camel@dhollis-lnx.sunera.com>
Message-ID: <Pine.LNX.4.61.0701311853390.13737@yvahk01.tjqt.qr>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
 <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
 <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
 <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
 <21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com>
 <3d57814d0701301424m67d22cdbg7afc0a1dab29c152@mail.gmail.com>
 <45BFC99A.8040805@garzik.org> <1170250461.12914.33.camel@dhollis-lnx.sunera.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2007 08:34, David Hollis wrote:
>Conversely, I've seen many cases of drivers that are developed by the
>community, but kept out-of-kernel forever due to various reasons.  Some
>of them are due to the code quality and the developers not accepting the
>feedback to get the drivers into shape to be 'kernel worthy', sometimes
>it seems to be a lack of interest from the developers to merge upstream.
>Maybe because they think they would lose control or something?

Putting the "codingstyle" control aside, often it's because things look
too hackish. Take ipt_ROUTE as an example. It won't get included, since
the "proper" way to do it would be using MARK and iproute2. But many users
don't get that [no criticism here], because ipt_ROUTE is so much easier.
(Probably because iproute2 and other netlink-using tools, like tc, lack
thorough documentation.)


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
